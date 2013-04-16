Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <516CBA1D.8070306@zytor.com>
References: <1365797627-20874-1-git-send-email-keescook@chromium.org>
	<1365797627-20874-7-git-send-email-keescook@chromium.org>
	<CAE9FiQXGjJCDAo41jxpy9bZJ2svKy8YY-zX7O4YDZPhKo7M43g@mail.gmail.com>
	<516A1D49.1050100@zytor.com>
	<CAG7+5M12cAavi9XBYoe39X=JtpWUu4wxjaAfOZP+=1qaKz7C+A@mail.gmail.com>
	<516C702C.2030209@zytor.com>
	<CAGXu5jJkA0y+5-or4vxUHE5GyNODSoefrYJO7scM1Jh56FoUuA@mail.gmail.com>
	<516C751B.4020505@zytor.com>
	<CAGXu5jJvGx=5YV3mw6DTO75HwO_Yn_vbTN2GkkZr-CiqJqw=_g@mail.gmail.com>
	<516CB7EE.8070702@zytor.com>
	<516CBA1D.8070306@zytor.com>
Date: Tue, 16 Apr 2013 09:08:56 -0700
Message-ID: <CAGXu5jLAbSBH4Twnx5mADMy5Y_TugHhZ2anprpE1PUZ1nt5Caw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH 6/6] x86: kaslr: relocate base offset at boot
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Eric Northup <digitaleric@google.com>, Yinghai Lu <yinghai@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, the arch/x86 maintainers <x86@kernel.org>, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Apr 15, 2013 at 7:40 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/15/2013 07:31 PM, H. Peter Anvin wrote:
>>
>> I also am starting to think that this really would be done better being
>> integrated with the decompressor code, since that code already ends up
>> moving the code around... no reason to do this again.
>>
>
> Another good reason to do this in the decompressor wrapper: it can be
> written in C that way.

This would make the code much more readable, for sure. And given that
the 64-bit relocation work happens after decompression, this seems
only right. Good idea! I'll start working on it.

-Kees

--
Kees Cook
Chrome OS Security
