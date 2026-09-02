import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/register_screen.dart';

import '../presentation/screens/dashboard/dashboard_screen.dart';

import '../presentation/screens/expenses/expenses_screen.dart';
import '../presentation/screens/expenses/add_expense_screen.dart';
import '../presentation/screens/expenses/edit_expense_screen.dart';

import '../presentation/screens/income/income_screen.dart';
import '../presentation/screens/income/add_income_screen.dart';
import '../presentation/screens/income/edit_income_screen.dart';

import '../presentation/screens/budgets/budgets_screen.dart';
import '../presentation/screens/budgets/add_budget_screen.dart';
import '../presentation/screens/budgets/edit_budget_screen.dart';

import '../presentation/screens/reports/reports_screen.dart';
import '../presentation/screens/notifications/notifications_screen.dart';
import '../presentation/screens/profile/profile_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    // =========================================================
    // AUTH
    // =========================================================

    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) {
        return const LoginScreen();
      },
    ),

    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) {
        return const RegisterScreen();
      },
    ),

    // =========================================================
    // DASHBOARD
    // =========================================================

    GoRoute(
      path: '/',
      name: 'dashboard',
      builder: (context, state) {
        return const DashboardScreen();
      },
    ),

    // =========================================================
    // EXPENSES
    // =========================================================

    GoRoute(
      path: '/expenses',
      name: 'expenses',
      builder: (context, state) {
        return const ExpensesScreen();
      },
      routes: [
        GoRoute(
          path: 'add',
          name: 'add-expense',
          builder: (context, state) {
            return const AddExpenseScreen();
          },
        ),

        GoRoute(
          path: 'edit/:id',
          name: 'edit-expense',
          builder: (context, state) {
            final id = int.tryParse(
              state.pathParameters['id'] ?? '',
            );

            if (id == null) {
              return const ExpensesScreen();
            }

            return EditExpenseScreen(
              expenseId: id,
            );
          },
        ),
      ],
    ),

    // =========================================================
    // INCOME
    // =========================================================

    GoRoute(
      path: '/income',
      name: 'income',
      builder: (context, state) {
        return const IncomeScreen();
      },
      routes: [
        GoRoute(
          path: 'add',
          name: 'add-income',
          builder: (context, state) {
            return const AddIncomeScreen();
          },
        ),

        GoRoute(
          path: 'edit/:id',
          name: 'edit-income',
          builder: (context, state) {
            final id = int.tryParse(
              state.pathParameters['id'] ?? '',
            );

            if (id == null) {
              return const IncomeScreen();
            }

            return EditIncomeScreen(
              incomeId: id,
            );
          },
        ),
      ],
    ),

    // =========================================================
    // BUDGETS
    // =========================================================

    GoRoute(
      path: '/budgets',
      name: 'budgets',
      builder: (context, state) {
        return const BudgetsScreen();
      },
      routes: [
        GoRoute(
          path: 'add',
          name: 'add-budget',
          builder: (context, state) {
            return const AddBudgetScreen();
          },
        ),

        GoRoute(
          path: 'edit/:id',
          name: 'edit-budget',
          builder: (context, state) {
            final id = int.tryParse(
              state.pathParameters['id'] ?? '',
            );

            if (id == null) {
              return const BudgetsScreen();
            }

            return EditBudgetScreen(
              budgetId: id,
            );
          },
        ),
      ],
    ),

    // =========================================================
    // REPORTS
    // =========================================================

    GoRoute(
      path: '/reports',
      name: 'reports',
      builder: (context, state) {
        return const ReportsScreen();
      },
    ),

    // =========================================================
    // NOTIFICATIONS
    // =========================================================

    GoRoute(
      path: '/notifications',
      name: 'notifications',
      builder: (context, state) {
        return const NotificationsScreen();
      },
    ),

    // =========================================================
    // PROFILE
    // =========================================================

    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) {
        return const ProfileScreen();
      },
    ),
  ],

  // =========================================================
  // ROUTER ERROR
  // =========================================================

  errorBuilder: (context, state) {
    return const _RouterErrorScreen();
  },
);

class _RouterErrorScreen extends StatelessWidget {
  const _RouterErrorScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('خطأ'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 420,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.error_outline_rounded,
                    size: 42,
                    color: Colors.red,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  'الصفحة غير موجودة',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall,
                ),

                const SizedBox(height: 10),

                Text(
                  'تعذر العثور على الصفحة التي طلبتها.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium,
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.go('/');
                    },
                    icon: const Icon(
                      Icons.home_rounded,
                    ),
                    label: const Text(
                      'العودة للرئيسية',
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: const Text(
                      'العودة للخلف',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}