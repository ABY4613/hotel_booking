# 🏨 Raintech Software Limited — Hotel Room Booking Coding Test

**Candidate:** Aby Babu  
**Position:** Software Developer  
**Assessment:** Hotel Room Booking — Developer Skills Assessment  
**Architecture:** MVC (Model-View-Controller) with Reusable Component Widgets  
**Framework:** Flutter (Dart 3.10+ / Flutter 3.38+)  

---

## 🌟 Overview & UI Fidelity

This solution implements a single-page **Hotel Management Pro PMS** application developed specifically according to the **Raintech Software Limited** technical specification and design theme.

### Key Highlights:
- **Exact UI & Font Theme Match:** 
  - Off-white/warm cream canvas (`#F4F1EA`)
  - Deep navy card headers (`#0F3B5F`) with clean rounded corners
  - Metallic brass/gold embossed vintage room badge (`[🛏️ 101]`)
  - Beige/tan pill action buttons (`#EBE4D5` / `#C7BCAB`)
  - High-precision typography and tabular ledger view matching all 3 Raintech PMS screenshots.
- **Code Length Reduction via Modular Widgets:** Standardized components (`StepCardContainer`, `RoomBadgeWidget`, `CustomDatePickerField`, `PriceSummaryWidget`, `BookingsTableWidget`, `StatusBannerWidget`, `CustomButton`, `RaintechHeader`).
- **Strict MVC Architecture:** Clean separation between pure data entities (`models/`), reactive state and business logic (`controllers/`), mock database services (`services/`), and UI presentation layers (`views/` & `widgets/`).

---

## 🗂️ Project Structure (MVC Architecture)

```
lib/
├── main.dart                          # Application entry point, Theme & Tab routing
├── models/                            # Data Models & Immutable Value Objects
│   ├── room_model.dart                # Room entity, RoomStatus enum & floor mapping
│   ├── booking_model.dart             # Booking record model with guest details
│   └── calculation_result.dart        # Immutable pricing, nights & validation result
├── controllers/                       # MVC Controller / Business Logic
│   └── booking_controller.dart        # Reactive state, calculation engine & validation
├── services/                          # Data Layer
│   └── mock_data_service.dart         # Room catalog & sample existing reservations
├── utils/                             # Design Tokens & Helpers
│   ├── app_colors.dart                # Raintech PMS brand palette & status colors
│   └── date_helper.dart               # Date math, DD/MM/YYYY formatting & Indian currency
├── widgets/                           # Reusable Modular UI Widgets (Code Reduction)
│   ├── raintech_header.dart           # Top header with logo, live search & clock
│   ├── step_card_container.dart       # Card container with dark navy header
│   ├── room_badge_widget.dart         # Gold metallic room badge [🛏️ R101]
│   ├── custom_date_picker.dart        # Inline date picker with calendar modal
│   ├── room_card_widget.dart          # Room card with capacity & availability status
│   ├── price_summary_widget.dart      # Itemized calculation breakdown & POS actions
│   ├── status_banner_widget.dart      # Clear error / warning / success feedback banners
│   ├── bookings_table_widget.dart     # Confirmed guest ledger table with actions
│   └── custom_button.dart             # Navy Primary, Beige Action & Danger buttons
└── views/                             # View Screens
    ├── hotel_booking_screen.dart      # 3-Step Guest Check-in View (Image 1)
    ├── floor_map_view.dart            # Interactive Floor Status & Donut View (Image 2)
    └── checkout_view.dart             # Departing Guest Check-out & Folio View (Image 3)

test/
├── booking_calculation_test.dart      # 10 comprehensive unit tests covering edge cases
└── widget_test.dart                   # Smoke test & UI tree verification
```

---

## 📋 Features Implemented

### 1. Core Requirements
- **Sample Room Catalog:** Hardcoded the 5 test rooms with exact rates:
  - `R101` — Deluxe Room — ₹3,500 / night (Max 2 Guests)
  - `R102` — Deluxe Room — ₹3,500 / night (Max 2 Guests)
  - `R201` — Executive Suite — ₹5,800 / night (Max 3 Guests)
  - `R202` — Executive Suite — ₹5,800 / night (Max 3 Guests)
  - `R301` — Family Room — ₹4,200 / night (Max 4 Guests)
- **Check-in & Check-out Date Selection:** Calendar pickers with dynamic duration updates.
- **Dynamic Price Calculation:** Automatically computes:
  $$\text{Total Price} = \text{Nights} \times \text{Price per Night} + \text{Extra Charges} + \text{GST}$$
- **Date Validation:**
  - Prevents check-in dates in the past.
  - Ensures check-out is strictly after check-in (minimum 1 night stay).
  - Explicit error banners rather than failing silently.

### 2. Bonus Features (All Completed)
- **Double Booking / Date Conflict Prevention:** Detects overlapping dates with existing bookings for the same room and shows a warning banner with conflicting guest details.
- **Max Guest Filter & Validation:** Allows filtering rooms by guest capacity (`2+`, `3+`, `4+`) and validates guest counts against room limits.
- **Live Confirmed Bookings Ledger:** Real-time table showing active check-in records with PDF ID proofs and actions.
- **Interactive Floor Map (Image 2):** 50 rooms across Floor 1 & Floor 2 with live status chips (Available, Occupied, Dirty, Maintenance, Blocked) and Occupancy % gauge.
- **Check-Out & Folio Module (Image 3):** Complete billing breakdown with mini-bar, room service, and payment processing.

---

## 🚀 How to Run the Project

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.10+ or later)
- Chrome / Edge browser, Android emulator, or Windows desktop build tools

### Steps to Run

1. **Clone the repository:**
   ```bash
   git clone <YOUR_GIT_REPO_URL>
   cd hotel_booking
   ```

2. **Get dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run Unit Tests:**
   ```bash
   flutter test
   ```

4. **Launch the Application:**
   - **On Chrome (Web):**
     ```bash
     flutter run -d chrome
     ```
   - **On Windows Desktop:**
     ```bash
     flutter run -d windows
     ```

---

## 🧪 Unit Test Coverage

Run `flutter test` to execute the automated test suite in `test/booking_calculation_test.dart`:
- ✅ Calculates exact nights between check-in and check-out.
- ✅ Computes `nights × pricePerNight` for all 5 sample rooms.
- ✅ Validates base amount, GST calculation, and total price breakdown.
- ✅ Rejects same-day check-in/check-out (0 nights).
- ✅ Rejects check-out dates before check-in dates.
- ✅ Rejects past check-in dates.
- ✅ Detects date overlap collisions for existing reservations.
- ✅ Verifies guest capacity filtering.
- ✅ Verifies reactive state updates and ledger additions.

---

## 🔮 What I Would Improve With More Time

1. **Backend Integration & Persistence:** Connect with a REST/GraphQL backend (or Supabase/Firebase) with SQLite offline cache for persistent room inventory and multi-user sync.
2. **Real-time WebSocket Updates:** Push live room status changes from housekeeping to the front desk floor map instantly.
3. **Advanced Invoice Export:** Client-side PDF generation for printing registration cards and guest folios with QR codes.
4. **Internationalization (i18n):** Multi-currency support (USD, EUR, AED, GBP) and multilingual interface.

---

*Submitted for Raintech Software Limited Developer Skills Assessment by Aby Babu.*
