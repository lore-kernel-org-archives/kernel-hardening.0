Reply-To: kernel-hardening@lists.openwall.com
References: <1448401114-24650-1-git-send-email-keescook@chromium.org>
 <CA+rthh-euk2hGGWjsDqXogWSmzmJNV1aiUVfnTfrzyQhndgbOQ@mail.gmail.com>
From: Clemens Ladisch <clemens@ladisch.de>
Message-ID: <56558826.1060202@ladisch.de>
Date: Wed, 25 Nov 2015 11:06:30 +0100
MIME-Version: 1.0
In-Reply-To: <CA+rthh-euk2hGGWjsDqXogWSmzmJNV1aiUVfnTfrzyQhndgbOQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [PATCH 0/2] introduce post-init read-only
 memory
To: Mathias Krause <minipli@googlemail.com>, kernel-hardening@lists.openwall.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, x86-ml <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Michael Ellerman <mpe@ellerman.id.au>, linux-arch@vger.kernel.org, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Mathias Krause wrote:
> [...]
> So, prior extending the usage of the __read_only annotation some
> toolchain support is needed. Maybe a gcc plugin that'll warn/error on
> code that writes to such a variable but is not __init itself.

Or mark them as "const".  This would require the initialization code to
cast it away, probably with a helper macro.


Regards,
Clemens
