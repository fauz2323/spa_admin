import 'package:flutter/material.dart';

class AppStrings {
  // App Info
  static const String appName = 'SPA Admin';
  static const String appSubtitle = 'Management System';

  // Auth
  static const String welcomeBack = 'Welcome Back';
  static const String signInSubtitle = 'Sign in to your admin account';
  static const String createAccount = 'Create Account';
  static const String registerSubtitle =
      'Fill in your information to get started';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String fullName = 'Full Name';
  static const String phoneNumber = 'Phone Number';
  static const String login = 'Login';
  static const String register = 'Register';
  static const String dontHaveAccount = "Don't have an account? ";
  static const String alreadyHaveAccount = "Already have an account? ";

  // Navigation
  static const String dashboard = 'Dashboard';
  static const String profile = 'Profile';
  static const String orderManagement = 'Order Management';
  static const String userManagement = 'User Management';
  static const String rewardManagement = 'Reward Management';
  static const String userRanking = 'User Ranking';
  static const String accountInfo = 'Account Information';
  static const String logout = 'Logout';

  // Dashboard
  static const String welcomeAdmin = 'Welcome Back, Admin!';
  static const String dashboardSubtitle =
      'Here\'s what\'s happening at your spa today';
  static const String totalUsers = 'Total Users';
  static const String dailyOrders = 'Daily Orders';
  static const String pendingOrders = 'Pending Orders';
  static const String completedOrders = 'Completed Orders';
  static const String todayRevenue = 'Today Revenue';
  static const String totalRevenue = 'Total Revenue';
  static const String viewAll = 'View All';

  // Orders
  static const String allOrders = 'All Orders';
  static const String pending = 'Pending';
  static const String booked = 'Booked';
  static const String inProgress = 'In Progress';
  static const String completed = 'Completed';
  static const String cancelled = 'Cancelled';
  static const String orderStatus = 'Order Status';
  static const String confirmBooking = 'Confirm Booking';
  static const String startService = 'Start Service';
  static const String completeService = 'Complete Service';
  static const String cancelOrder = 'Cancel Order';
  static const String bookingDate = 'Booking Date';
  static const String orderCreated = 'Order Created';
  static const String totalAmount = 'Total Amount';
  static const String specialNotes = 'Special Notes';
  static const String quickActions = 'Quick Actions';

  // Users
  static const String activeUsers = 'Active Users';
  static const String newThisMonth = 'New This Month';
  static const String active = 'Active';
  static const String inactive = 'Inactive';
  static const String joined = 'Joined';
  static const String memberSince = 'Member since';
  static const String activateUser = 'Activate User';
  static const String deactivateUser = 'Deactivate User';
  static const String personalInformation = 'Personal Information';
  static const String joinDate = 'Join Date';
  static const String rewardPoints = 'Reward Points';

  // Rewards
  static const String allTransactions = 'All Transactions';
  static const String pointsEarned = 'Points Earned';
  static const String pointsRedeemed = 'Points Redeemed';
  static const String totalEarned = 'Total Earned';
  static const String totalRedeemed = 'Total Redeemed';
  static const String netPoints = 'Net Points';
  static const String earned = 'Earned';
  static const String redeemed = 'Redeemed';
  static const String addRewardPoints = 'Add Reward Points';
  static const String userName = 'User Name';
  static const String points = 'Points';
  static const String reason = 'Reason';

  // Rankings
  static const String allTimeRankings = 'All Time Rankings';
  static const String thisMonthRankings = 'This Month Rankings';
  static const String thisYearRankings = 'This Year Rankings';
  static const String topPerformers = 'Top performers by reward points';

  // Account
  static const String changeProfilePicture = 'Change Profile Picture';
  static const String changePassword = 'Change Password';
  static const String currentPassword = 'Current Password';
  static const String newPassword = 'New Password';
  static const String confirmNewPassword = 'Confirm New Password';
  static const String saveChanges = 'Save Changes';
  static const String appSettings = 'App Settings';
  static const String notifications = 'Notifications';
  static const String notificationsSubtitle = 'Manage notification preferences';
  static const String darkMode = 'Dark Mode';
  static const String darkModeSubtitle = 'Switch to dark theme';
  static const String language = 'Language';
  static const String languageValue = 'English (US)';
  static const String accountActions = 'Account Actions';

  // Common
  static const String search = 'Search';
  static const String filter = 'Filter';
  static const String sortBy = 'Sort by:';
  static const String name = 'Name';
  static const String date = 'Date';
  static const String refresh = 'Refresh';
  static const String cancel = 'Cancel';
  static const String save = 'Save';
  static const String add = 'Add';
  static const String edit = 'Edit';
  static const String delete = 'Delete';
  static const String apply = 'Apply';
  static const String loading = 'Loading...';
  static const String saving = 'Saving...';
  static const String updating = 'Updating...';

  // Messages
  static const String noOrdersFound = 'No orders found';
  static const String noUsersFound = 'No users found';
  static const String noRewardTransactionsFound =
      'No reward transactions found';
  static const String noRankingsAvailable = 'No rankings available';
  static const String orderStatusUpdated = 'Order status updated successfully';
  static const String userActivated = 'User activated successfully';
  static const String userDeactivated = 'User deactivated successfully';
  static const String rewardPointsAdded = 'Reward points added successfully!';
  static const String accountInfoUpdated =
      'Account information updated successfully!';
  static const String passwordChanged = 'Password changed successfully!';
  static const String registrationSuccessful =
      'Registration successful! Please login.';
  static const String profilePictureUpdateSoon =
      'Profile picture update coming soon!';
  static const String languageSelectionSoon = 'Language selection coming soon!';
  static const String fillAllPasswordFields = 'Please fill all password fields';
  static const String passwordsDoNotMatch = 'New passwords do not match';
  static const String logoutConfirmation = 'Are you sure you want to logout?';

  // Validations
  static const String pleaseEnterEmail = 'Please enter your email';
  static const String pleaseEnterValidEmail = 'Please enter a valid email';
  static const String pleaseEnterPassword = 'Please enter your password';
  static const String passwordMinLength =
      'Password must be at least 6 characters';
  static const String pleaseEnterName = 'Please enter your name';
  static const String pleaseEnterPhone = 'Please enter your phone number';
  static const String pleaseConfirmPassword = 'Please confirm your password';
  static const String passwordsNotMatch = 'Passwords do not match';
}

class AppConstants {
  // API Endpoints (mock)
  static const String baseUrl = 'https://api.spa-admin.com';
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String ordersEndpoint = '/orders';
  static const String usersEndpoint = '/users';
  static const String rewardsEndpoint = '/rewards';

  // Shared Preferences Keys
  static const String isLoggedIn = 'is_logged_in';
  static const String userToken = 'user_token';
  static const String userId = 'user_id';
  static const String userName = 'user_name';
  static const String userEmail = 'user_email';

  // App Settings
  static const String appVersion = '1.0.0';
  static const String privacyPolicyUrl = 'https://spa-admin.com/privacy';
  static const String termsOfServiceUrl = 'https://spa-admin.com/terms';
  static const String supportEmail = 'support@spa-admin.com';

  // UI Constants - Flat Design
  static const double defaultPadding = 16.0;
  static const double cardElevation = 0.0;
  static const double borderRadius = 6.0;
  static const int animationDuration = 200;

  // Flat Design Colors
  static const Color primaryColor = Color(0xFF1976D2);
  static const Color primaryLight = Color(0xFF42A5F5);
  static const Color primaryDark = Color(0xFF0D47A1);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color dividerColor = Color(0xFFE0E0E0);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF616161);
  static const Color textHint = Color(0xFF9E9E9E);

  // Status Colors - Flat
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color errorColor = Color(0xFFF44336);
  static const Color infoColor = Color(0xFF2196F3);

  // Currency
  static const String currencySymbol = 'Rp';
  static const String currencyCode = 'IDR';
}

class AppFormats {
  static String formatCurrency(double amount) {
    return amount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  static String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  static String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  static String formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  static String formatPhoneNumber(String phone) {
    // Simple Indonesian phone number formatting
    if (phone.startsWith('+62')) {
      return phone;
    } else if (phone.startsWith('08')) {
      return '+62${phone.substring(1)}';
    } else {
      return '+62$phone';
    }
  }
}
