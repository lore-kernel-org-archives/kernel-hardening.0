Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <517AF92F.3000403@zytor.com>
Date: Fri, 26 Apr 2013 15:01:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
References: <1367003005-5560-1-git-send-email-keescook@chromium.org> <1367003005-5560-6-git-send-email-keescook@chromium.org> <CAE9FiQVA17TGuY5_DFGUL8OSMLx+yJQV1fhe7JDkaoq1a9-oSw@mail.gmail.com>
In-Reply-To: <CAE9FiQVA17TGuY5_DFGUL8OSMLx+yJQV1fhe7JDkaoq1a9-oSw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 5/6] x86: kaslr: select memory region from e820 maps
To: Yinghai Lu <yinghai@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, the arch/x86 maintainers <x86@kernel.org>, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 04/26/2013 02:51 PM, Yinghai Lu wrote:
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
> 

Yes, those would have to be excluded.  For correctness the mem= and
memmap= options should also be taken into account.

	-hpa
