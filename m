Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <565606C1.8080507@zytor.com>
Date: Wed, 25 Nov 2015 11:06:41 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
References: <1448401114-24650-1-git-send-email-keescook@chromium.org>	<CA+rthh-euk2hGGWjsDqXogWSmzmJNV1aiUVfnTfrzyQhndgbOQ@mail.gmail.com>	<5655F059.4010801@zytor.com> <CAGXu5jJiB8prW=Mf1qVow+2PfpK7YP4K916f6+GGnBhgDq9iCw@mail.gmail.com>
In-Reply-To: <CAGXu5jJiB8prW=Mf1qVow+2PfpK7YP4K916f6+GGnBhgDq9iCw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [PATCH 0/2] introduce post-init read-only
 memory
To: Kees Cook <keescook@chromium.org>
Cc: Mathias Krause <minipli@googlemail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, x86-ml <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Michael Ellerman <mpe@ellerman.id.au>, linux-arch <linux-arch@vger.kernel.org>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 11/25/2015 10:54 AM, Kees Cook wrote:
>>
>> We should not wait for compile-time support, that doesn't make any
>> sense.  What would be useful would be a way to override this on the
>> command line -- that way, if disabling RO or RO-after-init memory makes
>> something work, we have an instant diagnosis.
> 
> Seems easiest to have an arg just skip calling mark_rodata_ro(). I can add that.
> 

Exactly.

	-hpa
