Reply-To: kernel-hardening@lists.openwall.com
References: <564EF64F.1060903@redhat.com>
 <20151120191632.GX3818@brightrain.aerifal.cx>
From: Florian Weimer <fweimer@redhat.com>
Message-ID: <5654C074.3020908@redhat.com>
Date: Tue, 24 Nov 2015 20:54:28 +0100
MIME-Version: 1.0
In-Reply-To: <20151120191632.GX3818@brightrain.aerifal.cx>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel-hardening] System call interface changes
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 11/20/2015 08:16 PM, Rich Felker wrote:

>> This would have to be an opt-in feature, obviously, and applications
>> would have to opt in explicitly via some ELF flag (similar to what we
>> did for non-executable stacks).
> 
> I don't think that's necessary. The application (or for typical
> dynamic linking, just the build of libc.so) would just need to refrain
> from using the parameterized syscall so that the old opcode would not
> appear in its executable mappings.

The SYSCALL instruction is fairly short (0x0f 0x05), so it ends up in
process images by accident.  I think this calls for explicit blocking.

>> Do you think it would be feasible to encode the system call number in
>> the instruction stream instead, next to the instruction?  I think this
> 
> This was done on ARM in the old pre-EABI ABI, and it turned out to be
> a bad design, at least from standpoints other than security. Reading
> the syscall number out of the instruction stream was more expensive,
> incompatible with syscall() (which ended up requiring a special
> SYS_syscall that needed messy argument conventions), and incompatible
> with reasonable userspace coding of syscalls using inline functions
> rather than macros, where you would have to rely on constant
> propagation optimizations to be able to satisfy asm constraints.

Wouldn't it be possible to embed the constant in the assembly text,
using the C preprocessor?

But I appreciate your comments, they have been helpful.

Florian
