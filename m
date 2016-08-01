Reply-To: kernel-hardening@lists.openwall.com
From: Thomas Garnier <thgarnie@google.com>
Date: Mon,  1 Aug 2016 10:07:58 -0700
Message-Id: <1470071280-78706-1-git-send-email-thgarnie@google.com>
Subject: [kernel-hardening] [PATCH v1 0/2] x86/power/64: Make KASLR memory randomization compatible with hibernation
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Yinghai Lu <yinghai@kernel.org>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

***Background:
KASLR memory randomization for x86_64 was added when KASLR did not support hibernation. Now that it does, some changes are needed.

***Problems that needed solving:
Hibernation was failing on reboot with a GP fault when CONFIG_RANDOMIZE_MEMORY was enabled. Two issues were identified.

The original fault was due to a wrong physical address assigned to cr3. The problem was introduced with __PAGE_OFFSET becoming a global variable when randomized. The fix uses a define to use the glbobal or immediate value based on config settings.

The second isssue was that the temporary page table mapping did not support virtual addresses not aligned on PGD level. KASLR memory randomization will generated a random address aligned on PUD level. The fix correctly calculates the offset on all levels of the temporary page table.

***Parts:
 - 01/02: Support unaligned addresses (second issue)
 - 02/02: Fix __PAGE_OFFSET usage on assembly (first issue)
