MIME-Version: 1.0
In-Reply-To: <55fa194e-69bd-fe39-f915-6f77673aea36@iaik.tugraz.at>
References: <9df77051-ac01-bfe9-3cf7-4c2ecbcb9292@iaik.tugraz.at>
 <CAJcbSZHcAi37FfFBKF4MsC3WM-RY5ar_e1pgMScb=S3+_-wqVQ@mail.gmail.com> <55fa194e-69bd-fe39-f915-6f77673aea36@iaik.tugraz.at>
From: Thomas Garnier <thgarnie@google.com>
Date: Fri, 5 May 2017 08:47:37 -0700
Message-ID: <CAJcbSZEOMssjUoMUBmArNeuOPoZ0gQJmEQ_WQaSOPiHp1XcNaQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [RFC, PATCH] x86_64: KAISER - do not map
 kernel in user mode
To: Daniel Gruss <daniel.gruss@iaik.tugraz.at>
Cc: kernel list <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, "clementine.maurice@iaik.tugraz.at" <clementine.maurice@iaik.tugraz.at>, "moritz.lipp@iaik.tugraz.at" <moritz.lipp@iaik.tugraz.at>, Michael Schwarz <michael.schwarz@iaik.tugraz.at>, Richard Fellner <richard.fellner@student.tugraz.at>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Ingo Molnar <mingo@kernel.org>, "anders.fogh@gdata-adan.de" <anders.fogh@gdata-adan.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, May 5, 2017 at 1:23 AM, Daniel Gruss
<daniel.gruss@iaik.tugraz.at> wrote:
>
> On 04.05.2017 17:28, Thomas Garnier wrote:
>>
>> Please read the documentation on submitting patches [1] and coding style [2].
>
>
> I will have a closer look at that.
>
>>  - How this approach prevent the hardware attacks you mentioned? You
>> still have to keep a part of _text in the pagetable and an attacker
>> could discover it no? (and deduce the kernel base address).
>
>
> These parts are moved to a different section (.user_mapped) which is at a possibly predictable location - the location of the randomized parts of the kernel is independent of the location of .user_mapped.
> The code/data footprint for .user_mapped is quite small, helping to reduce or eliminate the attack surface...
>

If I get it right, it means you can leak the per-cpu address instead
of the kernel. Correct? That would be a problem because you can
elevate privilege by overwriting per-cpu variables. Leaking this
address means also defeating KASLR memory randomization [3] (cf paper
in the commit).

In theory you could put the code in the fixmap but you still have the
per-cpu variables and changing that is hard.

[3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=021182e52fe01c1f7b126f97fd6ba048dc4234fd

>> You also need to make it clear that btb attacks are still possible.
>
>
> By just increasing the KASLR randomization range, btb attacks can be mitigated (for free).

Correct, I hope we can do that.

>
>>  - What is the perf impact?
>
>
> It will vary for different machines. We have promising results (<1%) for an i7-6700K with representative benchmarks. However, for older systems or for workloads with a lot of pressure on some TLB levels, the performance may be much worse.

I think including performance data in both cases would be useful.


-- 
Thomas
