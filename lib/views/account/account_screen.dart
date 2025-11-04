import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/user.dart';
import '../../models/pricing.dart';
import '../../models/rule.dart';
import '../../controllers/dashboard_controller.dart';
import '../../services/user_api_service.dart';
import '../../services/pricing_api.dart';
import '../../colors.dart';
import '../../models/company.dart';
import '../../models/account.dart';
import '../../services/company_api_service.dart';
import '../../services/account_api_service.dart';
import 'user_information_tab.dart';
import 'price_manager_tab.dart';
import 'company_information_tab.dart';
import 'payment_information_tab.dart';
import 'account_setting_tab_navigation_bar.dart';

class AccountInformationScreen extends StatefulWidget {
  const AccountInformationScreen({super.key});

  @override
  State<AccountInformationScreen> createState() => _AccountInformationScreenState();
}

class _AccountInformationScreenState extends State<AccountInformationScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  User? _user;
  Company? _company;
  Account? _account;
  List<Pricing> _pricingList = [];
  bool _loading = true;
  String? _error;

  // User information fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Company information fields
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _companyPhoneController = TextEditingController();

  // Payment information fields
  final TextEditingController _stripeAccountIdController = TextEditingController();

  // Pricing fields
  final Map<String, TextEditingController> _pricingControllers = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _companyNameController.dispose();
    _websiteController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _companyPhoneController.dispose();
    _stripeAccountIdController.dispose();
    _pricingControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      // Load user
      final user = await DashboardController.loadUser();
      if (user == null) {
        throw Exception('Failed to load user');
      }

      // Load company
      Company? company;
      if (user.companyId != null) {
        company = await DashboardController.loadCompany(user.companyId);
      }

      // Load account (using company ID)
      Account? account;
      if (user.companyId != null) {
        account = await AccountAPI.getAccountByCompanyId(user.companyId!);
      }

      // Load pricing (using user ID as accountId)
      List<Pricing>? pricingList;
      if (user.id != null) {
        pricingList = await PricingAPI.getPricingByAccountId(user.id!);
      }

      setState(() {
        _user = user;
        _company = company;
        _account = account;
        _pricingList = pricingList ?? [];
        _loading = false;

        // Initialize user fields
        _firstNameController.text = user.firstName ?? '';
        _lastNameController.text = user.lastName ?? '';
        _emailController.text = user.email ?? '';
        _phoneController.text = user.phone ?? '';

        // Initialize company fields
        _companyNameController.text = company?.name ?? '';
        _websiteController.text = company?.website ?? '';
        _streetController.text = company?.street ?? '';
        _cityController.text = company?.city ?? '';
        _stateController.text = company?.state ?? '';
        _zipCodeController.text = company?.zipCode ?? '';
        _companyPhoneController.text = company?.phoneNumber ?? '';

        // Initialize payment fields
        _stripeAccountIdController.text = account?.stripeAccountId ?? '';

        // Initialize pricing controllers
        for (var pricing in _pricingList) {
          _pricingControllers[pricing.id] = TextEditingController(
            text: pricing.amount.toStringAsFixed(2),
          );
        }
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = 'Failed to load data: $e';
      });
    }
  }

  Future<void> _saveUserInformation() async {
    if (_user == null) return;

    try {
      final updatedUser = User(
        id: _user!.id,
        companyId: _user!.companyId,
        createdDate: _user!.createdDate,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
      );

      final result = await UserAPI.updateUser(updatedUser);
      if (result != null) {
        setState(() {
          _user = updatedUser;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User information updated successfully')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update user information')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _savePricing() async {
    if (_user == null || _user!.id == null) return;

    try {
      bool allSuccess = true;
      
      // Handle Hook Up Fee and Per Mile Amount
      const String hookUpKey = 'hook-up-fee';
      const String perMileKey = 'per-mile-amount';
      
      // Save Hook Up Fee
      final hookUpController = _pricingControllers[hookUpKey];
      if (hookUpController != null) {
        final hookUpFee = _pricingList.firstWhere(
          (p) => p.itemName.toLowerCase().contains('hook'),
          orElse: () => Pricing(
            id: '',
            itemName: 'Hook Up Fee',
            amount: 0.0,
            rule: Rule(unit: '', condition: ''),
            accountId: _user!.id!,
          ),
        );
        
        final newAmount = double.tryParse(hookUpController.text) ?? hookUpFee.amount;
        
        Pricing? result;
        // Check if pricing exists in the list (not just placeholder)
        final existingHookUp = _pricingList.firstWhere(
          (p) => p.itemName.toLowerCase().contains('hook'),
          orElse: () => Pricing(id: '', itemName: '', amount: 0.0, rule: Rule(unit: '', condition: ''), accountId: ''),
        );
        
        // Check if pricing actually exists in database (has a real ID)
        final pricingExists = existingHookUp.id.isNotEmpty && 
            _pricingList.any((p) => p.id == existingHookUp.id && p.id.isNotEmpty);
        
        if (!pricingExists) {
          // Create new pricing item (backend will generate ID)
          final newPricing = Pricing(
            id: '', // Backend will generate
            itemName: 'Hook Up Fee',
            amount: newAmount,
            rule: Rule(unit: '', condition: ''),
            accountId: _user!.id!,
          );
          result = await PricingAPI.createPricing(newPricing);
        } else {
          // Update existing pricing item
          final updatedPricing = Pricing(
            id: existingHookUp.id,
            itemName: existingHookUp.itemName,
            amount: newAmount,
            rule: existingHookUp.rule,
            accountId: existingHookUp.accountId,
          );
          result = await PricingAPI.updatePricing(updatedPricing);
        }
        
        if (result != null) {
          // Update the pricing in the list
          final index = _pricingList.indexWhere((p) => p.id == result!.id);
          if (index != -1) {
            _pricingList[index] = result;
          } else {
            _pricingList.add(result);
          }
        } else {
          allSuccess = false;
        }
      }
      
      // Save Per Mile Amount
      final perMileController = _pricingControllers[perMileKey];
      if (perMileController != null) {
        final perMile = _pricingList.firstWhere(
          (p) => p.itemName.toLowerCase().contains('mile') || p.itemName.toLowerCase().contains('per mile'),
          orElse: () => Pricing(
            id: '',
            itemName: 'Per Mile Amount',
            amount: 0.0,
            rule: Rule(unit: '', condition: ''),
            accountId: _user!.id!,
          ),
        );
        
        final newAmount = double.tryParse(perMileController.text) ?? perMile.amount;
        
        Pricing? result;
        // Check if pricing exists in the list (not just placeholder)
        final existingPerMile = _pricingList.firstWhere(
          (p) => p.itemName.toLowerCase().contains('mile') || p.itemName.toLowerCase().contains('per mile'),
          orElse: () => Pricing(id: '', itemName: '', amount: 0.0, rule: Rule(unit: '', condition: ''), accountId: ''),
        );
        
        // Check if pricing actually exists in database (has a real ID)
        final pricingExists = existingPerMile.id.isNotEmpty && 
            _pricingList.any((p) => p.id == existingPerMile.id && p.id.isNotEmpty);
        
        if (!pricingExists) {
          // Create new pricing item (backend will generate ID)
          final newPricing = Pricing(
            id: '', // Backend will generate
            itemName: 'Per Mile Amount',
            amount: newAmount,
            rule: Rule(unit: '', condition: ''),
            accountId: _user!.id!,
          );
          result = await PricingAPI.createPricing(newPricing);
        } else {
          // Update existing pricing item
          final updatedPricing = Pricing(
            id: existingPerMile.id,
            itemName: existingPerMile.itemName,
            amount: newAmount,
            rule: existingPerMile.rule,
            accountId: existingPerMile.accountId,
          );
          result = await PricingAPI.updatePricing(updatedPricing);
        }
        
        if (result != null) {
          // Update the pricing in the list
          final index = _pricingList.indexWhere((p) => p.id == result!.id);
          if (index != -1) {
            _pricingList[index] = result;
          } else {
            _pricingList.add(result);
          }
        } else {
          allSuccess = false;
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(allSuccess
                ? 'Pricing updated successfully'
                : 'Some pricing updates failed'),
          ),
        );
        
        // Reload data to get updated IDs
        if (allSuccess) {
          await _loadData();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _saveCompanyInformation() async {
    if (_company == null || _company!.id == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No company found to update')),
        );
      }
      return;
    }

    try {
      final updatedCompany = Company(
        id: _company!.id,
        name: _companyNameController.text.trim(),
        website: _websiteController.text.trim().isEmpty ? null : _websiteController.text.trim(),
        status: _company!.status,
        street: _streetController.text.trim().isEmpty ? null : _streetController.text.trim(),
        city: _cityController.text.trim().isEmpty ? null : _cityController.text.trim(),
        zipCode: _zipCodeController.text.trim().isEmpty ? null : _zipCodeController.text.trim(),
        state: _stateController.text.trim().isEmpty ? null : _stateController.text.trim(),
        phoneNumber: _companyPhoneController.text.trim().isEmpty ? null : _companyPhoneController.text.trim(),
        schedulingLink: _company!.schedulingLink,
      );

      final result = await CompanyAPI.updateCompany(updatedCompany);
      if (result != null) {
        setState(() {
          _company = updatedCompany;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Company information updated successfully')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update company information')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _savePaymentInformation() async {
    if (_company == null || _company!.id == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No company found. Payment information requires a company.')),
        );
      }
      return;
    }

    try {
      // If account doesn't exist, create it; otherwise update it
      Account updatedAccount;
      if (_account == null) {
        // Create new account
        updatedAccount = Account(
          id: '', // Will be generated by backend
          companyInformation: _company!.id!,
          stripeAccountId: _stripeAccountIdController.text.trim(),
        );
        
        final result = await AccountAPI.createAccount(updatedAccount);
        if (result != null) {
          setState(() {
            _account = result;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Payment information saved successfully')),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to save payment information')),
            );
          }
        }
      } else {
        // Update existing account
        updatedAccount = Account(
          id: _account!.id,
          companyInformation: _account!.companyInformation,
          stripeAccountId: _stripeAccountIdController.text.trim(),
        );

        final result = await AccountAPI.updateAccount(updatedAccount);
        if (result != null) {
          setState(() {
            _account = updatedAccount;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Payment information updated successfully')),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to update payment information')),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Account Information'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : Column(
                  children: [
                    const SizedBox(height: 30),
                    AccountSettingTabNavigationBar(
                      tabs: const [
                        'User Information',
                        'Company Information',
                        'Payment Information',
                        'Price Manager',
                      ],
                      selectedIndex: _tabController.index,
                      onTabChanged: (index) {
                        _tabController.animateTo(index);
                      },
                    ),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final screenWidth = MediaQuery.of(context).size.width;
                          final isLargeScreen = screenWidth >= 600;
                          final contentWidth = isLargeScreen ? screenWidth * 0.4 : screenWidth;

                          return Center(
                            child: SizedBox(
                              width: contentWidth,
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  UserInformationTab(
                                    firstNameController: _firstNameController,
                                    lastNameController: _lastNameController,
                                    emailController: _emailController,
                                    phoneController: _phoneController,
                                    onSave: _saveUserInformation,
                                  ),
                                  CompanyInformationTab(
                                    nameController: _companyNameController,
                                    websiteController: _websiteController,
                                    streetController: _streetController,
                                    cityController: _cityController,
                                    stateController: _stateController,
                                    zipCodeController: _zipCodeController,
                                    phoneNumberController: _companyPhoneController,
                                    onSave: _saveCompanyInformation,
                                  ),
                                  PaymentInformationTab(
                                    stripeAccountIdController: _stripeAccountIdController,
                                    onSave: _savePaymentInformation,
                                  ),
                                  PriceManagerTab(
                                    pricingList: _pricingList,
                                    pricingControllers: _pricingControllers,
                                    onSave: _savePricing,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }

}

