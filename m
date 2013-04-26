Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAE9FiQVA17TGuY5_DFGUL8OSMLx+yJQV1fhe7JDkaoq1a9-oSw@mail.gmail.com>
References: <1367003005-5560-1-git-send-email-keescook@chromium.org>
	<1367003005-5560-6-git-send-email-keescook@chromium.org>
	<CAE9FiQVA17TGuY5_DFGUL8OSMLx+yJQV1fhe7JDkaoq1a9-oSw@mail.gmail.com>
Date: Fri, 26 Apr 2013 15:01:38 -0700
Message-ID: <CAGXu5j+QHxnPLkz1+uD5=1SCBpcARbHTUKWOW6wB4LwWNhsw6Q@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH 5/6] x86: kaslr: select memory region from e820 maps
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, the arch/x86 maintainers <x86@kernel.org>, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Apr 26, 2013 at 2:51 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Fri, Apr 26, 2013 at 12:03 PM, Kees Cook <keescook@chromium.org> wrote:
>> This chooses the largest contiguous RAM region for the KASLR offset
>> to live in.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>> v2:
>>  - make sure to exclude e820 regions outside the 32-bit memory range.
>
> Do you need to execlude range that is used for initrd and possible
> command_line and boot_param ?

Yeah, and while doing a stress test here, I realized there's another
problem. In the original version of this, the stack and heap are set
up after relocation. In the C port, they're set up before, so there's
even more to avoid. To illustrate... here's a CONFIG_RELOCATABLE=n
boot:

LOAD_PHYS:0x0000000001000000
input:    0x0000000001dfe24d-0x00000000023db865
output:   0x0000000001000000-0x00000000023c98c0
heap:     0x00000000023e0740-0x00000000023e8740
stack:    0x00000000023ec698
chosen:   0x0000000001000000

(stack is just cheating and reporting sp in decompress_kernel)

And a CONFIG_RELOCATABLE=y and "noaslr" boot:

LOAD_PHYS:0x0000000001000000
input:    0x000000000108b25e-0x00000000016b3e96
output:   0x0000000000200000-0x00000000016a1db8
heap:     0x00000000016b9600-0x00000000016c1600
stack:    0x00000000016c5558
chosen:   0x0000000000200000

In that case, it's just so far under LOAD_PHYSICAL_START that it's
safe. But if KASLR picks an area overlapping input, heap, or stack
it's hosed. :)

-Kees

--
Kees Cook
Chrome OS Security
