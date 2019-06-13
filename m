Subject: Re: [RFC 00/10] Process-local memory allocations for hiding KVM
 secrets
References: <20190612170834.14855-1-mhillenb@amazon.de>
 <eecc856f-7f3f-ed11-3457-ea832351e963@intel.com>
From: Alexander Graf <graf@amazon.com>
Message-ID: <54a4d14c-b19b-339e-5a15-adb10297cb30@amazon.com>
Date: Thu, 13 Jun 2019 09:27:00 +0200
MIME-Version: 1.0
In-Reply-To: <eecc856f-7f3f-ed11-3457-ea832351e963@intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
To: Dave Hansen <dave.hansen@intel.com>, Marius Hillenbrand <mhillenb@amazon.de>, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, Alexander Graf <graf@amazon.de>, David Woodhouse <dwmw@amazon.co.uk>, the arch/x86 maintainers <x86@kernel.org>, Andy
 Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>


On 12.06.19 21:55, Dave Hansen wrote:
> On 6/12/19 10:08 AM, Marius Hillenbrand wrote:
>> This patch series proposes to introduce a region for what we call
>> process-local memory into the kernel's virtual address space.
> It might be fun to cc some x86 folks on this series.  They might have
> some relevant opinions. ;)
>
> A few high-level questions:
>
> Why go to all this trouble to hide guest state like registers if all the
> guest data itself is still mapped?


(jumping in for Marius, he's offline today)

Glad you asked :). I hope this cover letter explains well how to achieve 
guest data not being mapped:

https://lkml.org/lkml/2019/1/31/933


> Where's the context-switching code?  Did I just miss it?


I'm not sure I understand the question. With this mechanism, the global 
linear map pages are just not present anymore, so there is no context 
switching needed. For the process local memory, the page table is 
already mm local, so we don't need to do anything special during context 
switch, no?


Alex
