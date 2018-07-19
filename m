From: Ahmed Abd El Mawgood <ahmedsoliman0x666@gmail.com>
Subject: [PATCH 1/3] [RFC V3] KVM: X86: Memory ROE documentation
Date: Thu, 19 Jul 2018 23:38:00 +0200
Message-Id: <20180719213802.17161-2-ahmedsoliman0x666@gmail.com>
In-Reply-To: <20180719213802.17161-1-ahmedsoliman0x666@gmail.com>
References: <20180719213802.17161-1-ahmedsoliman0x666@gmail.com>
To: kvm@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, virtualization@lists.linux-foundation.org, linux-doc@vger.kernel.org, x86@kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com, nathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, hpa@zytor.com, Kees Cook <keescook@chromium.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, David Hildenbrand <david@redhat.com>, Boris Lukashev <blukashev@sempervictus.com>, David Vrabel <david.vrabel@nutanix.com>, nigel.edwards@hpe.com, Rik van Riel <riel@surriel.com>, Ahmed Abd El Mawgood <ahmedsoliman0x666@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Following up with my previous threads on KVM assisted Anti rootkit
protections.
The current version doesn't address the attacks involving pages
remapping. It is still design in progress, nevertheless, it will be in
my later patch sets.

Signed-off-by: Ahmed Abd El Mawgood <ahmedsoliman0x666@gmail.com>
---
 Documentation/virtual/kvm/hypercalls.txt | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/Documentation/virtual/kvm/hypercalls.txt b/Documentation/virtual/kvm/hypercalls.txt
index a890529c63ed..a9db68adb7c9 100644
--- a/Documentation/virtual/kvm/hypercalls.txt
+++ b/Documentation/virtual/kvm/hypercalls.txt
@@ -121,3 +121,17 @@ compute the CLOCK_REALTIME for its clock, at the same instant.
 
 Returns KVM_EOPNOTSUPP if the host does not use TSC clocksource,
 or if clock type is different than KVM_CLOCK_PAIRING_WALLCLOCK.
+
+7. KVM_HC_HMROE
+----------------
+Architecture: x86
+Status: active
+Purpose: Hypercall used to apply Read-Only Enforcement to guest pages
+Usage:
+     a0: start address of page that should be protected.
+
+This hypercall lets a guest kernel to have part of its read/write memory
+converted into read-only.  This action is irreversible. KVM_HC_HMROE can
+not be triggered from guest Ring 3 (user mode). The reason is that user
+mode malicious software can make use of it enforce read only protection on
+an arbitrary memory page thus crashing the kernel.
-- 
2.16.4
