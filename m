MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CACi5LpNrd+fqOCiA3HnJ6brTCW+v0c1tVPcfFS7Ms0tE0LXmQg@mail.gmail.com>
References: <1486014168-1279-1-git-send-email-bhsharma@redhat.com>
 <CAGXu5jKYMLU1f3bWism+V59cuAeQnm7Fc9zncamq9S8guGR6TQ@mail.gmail.com> <CACi5LpNrd+fqOCiA3HnJ6brTCW+v0c1tVPcfFS7Ms0tE0LXmQg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 2 Feb 2017 11:19:28 -0800
Message-ID: <CAGXu5j+FVDAHx9WvUm1uM9OHQLD4FEeToVfB91hJcPBi3udiNw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH 0/2] RFC: Adjust powerpc ASLR elf randomness
To: Bhupesh Sharma <bhsharma@redhat.com>
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Daniel Cashman <dcashman@google.com>, Michael Ellerman <mpe@ellerman.id.au>, Bhupesh SHARMA <bhupesh.linux@gmail.com>, Alexander Graf <agraf@suse.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Anatolij Gustschin <agust@denx.de>, Alistair Popple <alistair@popple.id.au>, Matt Porter <mporter@kernel.crashing.org>, Vitaly Bordug <vitb@kernel.crashing.org>, Scott Wood <oss@buserror.net>, Kumar Gala <galak@kernel.crashing.org>, Daniel Cashman <dcashman@android.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 2, 2017 at 10:08 AM, Bhupesh Sharma <bhsharma@redhat.com> wrote:
> On Thu, Feb 2, 2017 at 7:51 PM, Kees Cook <keescook@chromium.org> wrote:
>> On Wed, Feb 1, 2017 at 9:42 PM, Bhupesh Sharma <bhsharma@redhat.com> wrote:
>>> The 2nd patch increases the ELF_ET_DYN_BASE value from the current
>>> hardcoded value of 0x2000_0000 to something more practical,
>>> i.e. TASK_SIZE - PAGE_SHIFT (which makes sense especially for
>>> 64-bit platforms which would like to utilize more randomization
>>> in the load address of a PIE elf).
>>
>> I don't think you want this second patch. Moving ELF_ET_DYN_BASE to
>> the top of TASK_SIZE means you'll be constantly colliding with stack
>> and mmap randomization. 0x20000000 is way better since it randomizes
>> up from there towards the mmap area.
>>
>> Is there a reason to avoid the 32-bit memory range for the ELF addresses?
>
> I think you are right. Hmm, I think I was going by my particular use
> case which might not be required for generic PPC platforms.
>
> I have one doubt though - I have primarily worked on arm64 and x86
> architectures and there I see there 64-bit user space applications
> using the 64-bit load addresses/ranges. I am not sure why PPC64 is
> different historically.

x86's ELF_ET_DYN_BASE is (TASK_SIZE / 3 * 2), so it puts it ET_DYN
base at the top third of the address space. (In theory, this is to
avoid interpreter collisions, but I'm working on removing that
restriction, as it seems pointless.)

Other architectures have small ELF_ET_DYN_BASEs, which is good: it
allows them to have larger entropy for ET_DYN.

-Kees

-- 
Kees Cook
Pixel Security
