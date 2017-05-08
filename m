References: <9df77051-ac01-bfe9-3cf7-4c2ecbcb9292@iaik.tugraz.at>
 <CAJcbSZHcAi37FfFBKF4MsC3WM-RY5ar_e1pgMScb=S3+_-wqVQ@mail.gmail.com>
 <55fa194e-69bd-fe39-f915-6f77673aea36@iaik.tugraz.at>
From: Daniel Gruss <daniel.gruss@iaik.tugraz.at>
Message-ID: <56c2e0f0-361c-91f1-611f-37c6ea4c823f@iaik.tugraz.at>
Date: Mon, 8 May 2017 15:23:59 +0200
MIME-Version: 1.0
In-Reply-To: <55fa194e-69bd-fe39-f915-6f77673aea36@iaik.tugraz.at>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [RFC, PATCH] x86_64: KAISER - do not map
 kernel in user mode
To: Thomas Garnier <thgarnie@google.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, "clementine.maurice@iaik.tugraz.at" <clementine.maurice@iaik.tugraz.at>, "moritz.lipp@iaik.tugraz.at" <moritz.lipp@iaik.tugraz.at>, Michael Schwarz <michael.schwarz@iaik.tugraz.at>, Richard Fellner <richard.fellner@student.tugraz.at>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Ingo Molnar <mingo@kernel.org>, "anders.fogh@gdata-adan.de" <anders.fogh@gdata-adan.de>
List-ID: <kernel-hardening.lists.openwall.com>

On 05.05.2017 10:23, Daniel Gruss wrote:
>>  - How this approach prevent the hardware attacks you mentioned? You
>> still have to keep a part of _text in the pagetable and an attacker
>> could discover it no? (and deduce the kernel base address).
>
> These parts are moved to a different section (.user_mapped) which is at a possibly predictable location - the location
> of the randomized parts of the kernel is independent of the location of .user_mapped.
> The code/data footprint for .user_mapped is quite small, helping to reduce or eliminate the attack surface...

We just discussed that in our group again: although we experimented with this part, it's not yet included in the patch. 
The solution we sketched is, as I wrote, we map the required (per-thread) variables in the user CR3 to a fixed location 
in memory. During the context switch, only this fixed part remains mapped but not the randomized pages. This is not a 
lot of work, because it's just mapping a few more pages and fixing a 1 or 2 lines in the context switch.
