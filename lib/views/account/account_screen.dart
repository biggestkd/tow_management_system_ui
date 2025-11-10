import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../../models/user.dart';
import '../../models/pricing.dart';
import '../../models/company.dart';
import '../../models/account.dart';
import '../../controllers/account_controller.dart';
import '../../colors.dart';
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

  // Payment information fields
  final TextEditingController _stripeAccountIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        // Force rebuild when tab changes to reset forms with saved data
        setState(() {});
      }
    });
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _stripeAccountIdController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      // Get current authenticated user ID from Amplify Auth
      final authUser = await Amplify.Auth.getCurrentUser();
      final userId = authUser.userId;

      // Load user information using Account_Controller
      final user = await AccountController.loadUserInformation(userId);
      if (user == null) {
        throw Exception('Failed to load user');
      }

      // Load company information using Account_Controller
      Company? company;
      if (user.companyId != null && user.companyId!.isNotEmpty) {
        company = await AccountController.loadCompanyInformation(user.companyId!);
      }

      // Load account (using company ID) - keep using AccountAPI directly as there's no Account_Controller method
      Account? account;
      if (user.companyId != null && user.companyId!.isNotEmpty) {
        account = await AccountAPI.getAccountByCompanyId(user.companyId!);
      }

      // Load pricing using Account_Controller
      List<Pricing>? pricingList;
      if (user.companyId != null && user.companyId!.isNotEmpty) {
        pricingList = await AccountController.loadPrices(user.companyId!);
      }

      setState(() {
        _user = user;
        _company = company;
        _account = account;
        _pricingList = pricingList ?? [];
        _loading = false;

        // Initialize payment fields
        _stripeAccountIdController.text = account?.stripeAccountId ?? '';
      });
    } on SignedOutException {
      setState(() {
        _loading = false;
        _error = 'User is not signed in';
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = 'Failed to load data: $e';
      });
    }
  }

  Future<void> _saveUserInformation(String firstName, String lastName, String email, String phone) async {
    if (_user == null) return;

    try {
      final updatedUser = User(
        id: _user!.id,
        companyId: _user!.companyId,
        createdDate: _user!.createdDate,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
      );

      // Use Account_Controller.saveContactInformation
      final error = await AccountController.saveContactInformation(updatedUser);
      
      if (error == null) {
        // Success - reload data to get the latest information
        await _loadData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Contact information saved successfully')),
          );
        }
      } else {
        // Error occurred
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save contact information: $error')),
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

  Future<void> _savePricing(List<Pricing> prices) async {
    try {
      // Use Account_Controller.updatePrices
      final error = await AccountController.updatePrices(prices);
      
      if (error == null) {
        // Success - reload data to get the latest information
        await _loadData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pricing updated successfully')),
          );
        }
      } else {
        // Error occurred
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update pricing: $error')),
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

  Future<void> _saveCompanyInformation(String name, String website, String street, String city, String zipCode, String state, String phoneNumber) async {
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
        name: name,
        website: website.isEmpty ? null : website,
        status: _company!.status,
        street: street.isEmpty ? null : street,
        city: city.isEmpty ? null : city,
        zipCode: zipCode.isEmpty ? null : zipCode,
        state: state.isEmpty ? null : state,
        phoneNumber: phoneNumber.isEmpty ? null : phoneNumber,
        schedulingLink: _company!.schedulingLink,
      );

      // Use Account_Controller.saveCompanyInformation
      final error = await AccountController.saveCompanyInformation(updatedCompany);
      
      if (error == null) {
        // Success - reload data to get the latest information
        await _loadData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Company information saved successfully')),
          );
        }
      } else {
        // Error occurred
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save company information: $error')),
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
                                    key: ValueKey('user_info_${_user?.id}_${_user?.firstName}_${_user?.lastName}_${_user?.email}_${_user?.phone}'),
                                    firstName: _user?.firstName ?? '',
                                    lastName: _user?.lastName ?? '',
                                    email: _user?.email ?? '',
                                    phone: _user?.phone ?? '',
                                    onSave: _saveUserInformation,
                                  ),
                                  CompanyInformationTab(
                                    key: ValueKey('company_info_${_company?.id}_${_company?.name}_${_company?.street}_${_company?.city}_${_company?.state}'),
                                    name: _company?.name ?? '',
                                    website: _company?.website ?? '',
                                    street: _company?.street ?? '',
                                    city: _company?.city ?? '',
                                    zipCode: _company?.zipCode ?? '',
                                    state: _company?.state ?? '',
                                    phoneNumber: _company?.phoneNumber ?? '',
                                    onSave: _saveCompanyInformation,
                                  ),
                                  PaymentInformationTab(
                                    stripeAccountIdController: _stripeAccountIdController,
                                    onSave: _savePaymentInformation,
                                  ),
                                  PriceManagerTab(
                                    key: ValueKey('price_manager_${_pricingList.length}_${_pricingList.map((p) => '${p.id}_${p.amount}').join('_')}'),
                                    pricingList: _pricingList,
                                    accountId: _company?.id,
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

