Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 5 Oct 2016 18:09:01 +0100
Message-ID: <CAKv+Gu_7AdRk7O-Mt8oS=t6prJY56=nS5CS1stgfqHzJ--YD9Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] initcall randomization
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@fedoraproject.org>, Mark Rutland <mark.rutland@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

Did anyone ever look into whether there is anything to gain in terms
of hardening from randomizing the order initcalls are issued at each
level? I know entropy is hard to come by at this stage, but on recent
UEFI systems, this is something we could potentially solve
generically. (It may uncover some breakage as well, but only hidden
breakage that could already surface at any time due to linker changes,
so I think this could serve as a diagnostic option as well)

Since boot time mappings are often performed in initcalls, this could
potentially reduce the predictability of the layout of the virtual
kernel space. But before I start experimenting with this, I thought
I'd ask if anyone has ever looked into this.

Regards,
Ard.
