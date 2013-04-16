Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <516DD323.3050201@zytor.com>
Date: Tue, 16 Apr 2013 15:39:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
References: <1365797627-20874-1-git-send-email-keescook@chromium.org> <1365797627-20874-5-git-send-email-keescook@chromium.org> <516DCEF3.6030803@zytor.com> <CAGXu5jJ8Gbuj6=ebzu7Wwx2MRD-7qKg-cmhPz_gN6nWCpg-rFg@mail.gmail.com>
In-Reply-To: <CAGXu5jJ8Gbuj6=ebzu7Wwx2MRD-7qKg-cmhPz_gN6nWCpg-rFg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 4/6] x86: relocs: build separate 32/64-bit tools
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 04/16/2013 03:38 PM, Kees Cook wrote:
>>
>> Have simple wrapper files which do:
>>
>> /* relocs_32.c */
>> #define ELF_BITS 32
>> #include "relocs.c"
>>
>> /* relocs_64.c */
>> #define ELF_BITS 64
>> #include "relocs.c"
> 
> That's what I did in my first pass, but it seemed even worse to me. I
> will go back to this.
> 

Actually, I'm trying to see if I can refactor this into one binary.
Hang on a few.

	-hpa
