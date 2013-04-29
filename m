Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <alpine.LRH.2.02.1304291124520.5728@tundra.namei.org>
References: <1367003005-5560-1-git-send-email-keescook@chromium.org>
	<1367003005-5560-4-git-send-email-keescook@chromium.org>
	<517AF5F2.50404@zytor.com>
	<alpine.LRH.2.02.1304291124520.5728@tundra.namei.org>
Date: Mon, 29 Apr 2013 10:43:13 -0700
Message-ID: <CAGXu5jJwu0rCLJo4Qd4Vook11+_yZ=L0YJvHxf8Cx7gyo3yHYg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Subject: Re: [kernel-hardening] Re: [PATCH 3/6] x86: kaslr: return location
 from decompress_kernel
To: James Morris <jmorris@namei.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Apr 28, 2013 at 6:25 PM, James Morris <jmorris@namei.org> wrote:
> On Fri, 26 Apr 2013, H. Peter Anvin wrote:
>
>> > +   noaslr          [X86]
>> > +                   Disable kernel base offset ASLR (Address Space
>> > +                   Layout Randomization) if built into the kernel.
>> > +
>> >     noautogroup     Disable scheduler automatic task group creation.
>> >
>> >     nobats          [PPC] Do not use BATs for mapping kernel lowmem
>>
>> Calling it "nokaslr" might be useful to note that it is specifically
>> about the kernel.
>
> Agreed.

Yeah, good call. I'll get this changed. Thanks!

-Kees

--
Kees Cook
Chrome OS Security
