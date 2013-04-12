Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Fri, 12 Apr 2013 13:13:41 -0700
Message-Id: <1365797627-20874-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v2 0/6] kernel ASLR
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

This splits up the relocs tool changes into the separate logical pieces,
which should be easier to review. I could use some suggestions on a
better way to build it in the 4th patch. What I have now seems ugly,
but Kbuild would not give me its secrets.

RO IDT was sent separately is is living in the tip/kaslr tree at the
moment. The main logic for KASLR remains split into two pieces: offset
selection and offset usage.

Thanks,

-Kees
