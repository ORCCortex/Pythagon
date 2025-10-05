# App Screenshots

This document describes the key screens and UI components of the Pythagon app.

## Home Screen

**Description**: The main dashboard that displays all captured math problems.

**Key Features**:
- Header with app branding and description
- List of problem cards with thumbnails
- Empty state for first-time users
- Floating action buttons for camera and gallery access

**UI Elements**:
- **Header**: App icon, title "Pythagon", subtitle describing functionality
- **Problem Cards**: Thumbnail image, problem title, creation date, status indicator
- **FAB (Camera)**: Primary blue circular button with camera icon
- **FAB (Gallery)**: Secondary blue circular button with gallery icon
- **Empty State**: Centered illustration with call-to-action text

**Mock Screenshot Description**:
```
┌─────────────────────────────────────┐
│ Pythagon                           │
│ 🧮                                 │
│ Math Homework Solver               │
│ Capture your math problems...      │
│                                    │
│ ┌─────────────────────────────────┐ │
│ │ [IMG] Problem 1    2 hours ago  │ │
│ │       Status: Pending    ⋮      │ │
│ └─────────────────────────────────┘ │
│                                    │
│ ┌─────────────────────────────────┐ │
│ │ [IMG] Problem 2    1 day ago    │ │
│ │       Status: Solved     ⋮      │ │
│ └─────────────────────────────────┘ │
│                                    │
│                              🖼️    │
│                              📷    │
└─────────────────────────────────────┘
```

## Camera Screen

**Description**: Full-screen camera interface for capturing math problems.

**Key Features**:
- Live camera preview
- Capture button with visual feedback
- Camera switching functionality
- Flash toggle (placeholder)
- Problem framing overlay

**UI Elements**:
- **Preview Area**: Full-screen camera feed
- **Overlay Frame**: Semi-transparent border for problem alignment
- **Capture Button**: Large circular button at bottom center
- **Camera Switch**: Icon button for front/back camera toggle
- **Flash Toggle**: Icon button for flash control
- **Close Button**: X button in top-left corner

**Mock Screenshot Description**:
```
┌─────────────────────────────────────┐
│ ✕  Capture Problem                 │
│                                    │
│ ┌───┐                              │
│ │   │ LIVE CAMERA PREVIEW          │
│ │   │                              │
│ │   │  ┌─────────────────────┐     │
│ │   │  │                     │     │
│ │   │  │  Problem Area       │     │
│ │   │  │                     │     │
│ │   │  └─────────────────────┘     │
│ │   │                              │
│ └───┘                              │
│                                    │
│  🔄          ⚪          ⚡        │
│                                    │
└─────────────────────────────────────┘
```

## Problem Viewer Screen

**Description**: Detailed view of individual math problems with zoom capabilities.

**Key Features**:
- Zoomable image viewer with pan support
- Problem metadata display
- Status tracking
- Action buttons for analysis and sharing
- Delete functionality

**UI Elements**:
- **Image Viewer**: Top 2/3 of screen with zoom/pan support
- **Details Panel**: Bottom 1/3 with problem information
- **Status Indicator**: Colored chip showing current status
- **Action Buttons**: Analyze and Share buttons
- **Delete Button**: Trash icon in app bar

**Mock Screenshot Description**:
```
┌─────────────────────────────────────┐
│ ← Problem 1                    🗑️   │
│                                    │
│ ████████████████████████████████   │
│ ████████████████████████████████   │
│ ████████ MATH PROBLEM ███████████   │
│ ████████████████████████████████   │
│ ████████████████████████████████   │
│ ████████████████████████████████   │
│                                    │
│ ● Pending Analysis                 │
│                                    │
│ Created: Today at 14:30            │
│                                    │
│ [  📊 Analyze Problem  ] [ 📱 Share]│
└─────────────────────────────────────┘
```

## Empty State

**Description**: Displayed when no problems have been captured yet.

**Mock Screenshot Description**:
```
┌─────────────────────────────────────┐
│ Pythagon                           │
│                                    │
│              📷                    │
│                                    │
│         No problems yet            │
│                                    │
│  Tap the camera button to capture  │
│      your first math problem       │
│                                    │
│                              🖼️    │
│                              📷    │
└─────────────────────────────────────┘
```

## Problem Status Indicators

### Pending
- **Color**: Orange
- **Icon**: ⏳ (pending icon)
- **Text**: "Pending Analysis"

### Analyzing
- **Color**: Blue  
- **Icon**: ⏳ (hourglass icon)
- **Text**: "Analyzing..."
- **Additional**: Loading spinner

### Solved
- **Color**: Green
- **Icon**: ✅ (check circle)
- **Text**: "Solved"

### Error
- **Color**: Red
- **Icon**: ❌ (error icon)
- **Text**: "Error"

## Navigation Flow

```
Home Screen
    ├── Camera Screen → Problem Viewer
    ├── Gallery Picker → Problem Viewer
    └── Problem Card → Problem Viewer
                           └── Back to Home
```

## Responsive Design Notes

- All screens adapt to different screen sizes
- Touch targets meet accessibility guidelines (44dp minimum)
- Text scales with system font size settings
- High contrast mode support through Material Design theming

## Accessibility Features

- Semantic labels for screen readers
- High contrast color schemes
- Large touch targets
- Voice-over navigation support
- Keyboard navigation (where applicable)