// home.dart
import 'package:flutter/material.dart';
import 'package:notecounta/pages/notecounta.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Notecounta();
  }
}

//DATABASE
// # Connect to Supabase via connection pooling
// DATABASE_URL="postgresql://postgres.ewdtwuhzqlbbnqalxhnm:[YOUR-PASSWORD]@aws-0-ap-southeast-1.pooler.supabase.com:6543/postgres?pgbouncer=true"

// # Direct connection to the database. Used for migrations
// DIRECT_URL="postgresql://postgres.ewdtwuhzqlbbnqalxhnm:[YOUR-PASSWORD]@aws-0-ap-southeast-1.pooler.supabase.com:5432/postgres"
