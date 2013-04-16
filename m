Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1365797627-20874-1-git-send-email-keescook@chromium.org>
References: <1365797627-20874-1-git-send-email-keescook@chromium.org>
Date: Tue, 16 Apr 2013 11:08:42 -0700
Message-ID: <CAGXu5jKjR46sZ4XnfzaJ0daNC82bqY2wdbTZn05Wz3v5hkP5BA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH v2 0/6] kernel ASLR
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Apr 12, 2013 at 1:13 PM, Kees Cook <keescook@chromium.org> wrote:
> This splits up the relocs tool changes into the separate logical pieces,
> which should be easier to review. I could use some suggestions on a
> better way to build it in the 4th patch. What I have now seems ugly,
> but Kbuild would not give me its secrets.

How does the relocation portion of this series look? It's separate
from the ASLR logic, but required for it. Do those changes look good
for the tip/kaslr tree?

Thanks,

-Kees

--
Kees Cook
Chrome OS Security
