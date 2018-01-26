MIME-Version: 1.0
In-Reply-To: <8eb12a75-4957-d5eb-9a14-387788728b8a@huawei.com>
References: <20180124175631.22925-1-igor.stoppa@huawei.com>
 <20180124175631.22925-5-igor.stoppa@huawei.com> <CAG48ez0JRU8Nmn7jLBVoy6SMMrcj46R0_R30Lcyouc4R9igi-g@mail.gmail.com>
 <6c6a3f47-fc5b-0365-4663-6908ad1fc4a7@huawei.com> <CAFUG7CfP_UyEH=1dmX=wsBz73+fQ0syDAy8ArKT0d4nMyf9n-g@mail.gmail.com>
 <20180125153839.GA3542@redhat.com> <8eb12a75-4957-d5eb-9a14-387788728b8a@huawei.com>
From: Boris Lukashev <blukashev@sempervictus.com>
Date: Fri, 26 Jan 2018 11:36:30 -0500
Message-ID: <CAFUG7CeAfymvCC5jpBSM88X=8nSu-ktE0h81Ws1dAO0KrZk=9w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [PATCH 4/6] Protectable Memory
To: Igor Stoppa <igor.stoppa@huawei.com>
Cc: Jerome Glisse <jglisse@redhat.com>, Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, Michal Hocko <mhocko@kernel.org>, Laura Abbott <labbott@redhat.com>, Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <willy@infradead.org>, Christoph Lameter <cl@linux.com>, linux-security-module <linux-security-module@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, kernel list <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 26, 2018 at 7:28 AM, Igor Stoppa <igor.stoppa@huawei.com> wrote:
> On 25/01/18 17:38, Jerome Glisse wrote:
>> On Thu, Jan 25, 2018 at 10:14:28AM -0500, Boris Lukashev wrote:
>>> On Thu, Jan 25, 2018 at 6:59 AM, Igor Stoppa <igor.stoppa@huawei.com> wrote:
>>
>> [...]
>>
>>> DMA/physmap access coupled with a knowledge of which virtual mappings
>>> are in the physical space should be enough for an attacker to bypass
>>> the gating mechanism this work imposes. Not trivial, but not
>>> impossible. Since there's no way to prevent that sort of access in
>>> current hardware (especially something like a NIC or GPU working
>>> independently of the CPU altogether)
>
> [...]
>
>> I am not saying that this can not happen but that we are trying our best
>> to avoid it.
>
> How about an opt-in verification, similar to what proposed by Boris
> Lukashev?
>
> When reading back the data, one could access the pointer directly and
> bypass the verification, or could use a function that explicitly checks
> the integrity of the data.
>
> Starting from an unprotected kmalloc allocation, even just turning the
> data into R/O is an improvement, but if one can afford the overhead of
> performing the verification, why not?
>

I like the idea of making the verification call optional for consumers
allowing for fast/slow+hard paths depending on their needs.
Cant see any additional vectors for abuse (other than the original
ones effecting out-of-band modification) introduced by having
verify/normal callers, but i've not had enough coffee yet. Any access
races or things like that come to mind for anyone? Shouldn't happen
with a write-once allocation, but again, lacking coffee.

> It would still be better if the service was provided by the library,
> instead than implemented by individual users, I think.
>
> --
> igor

-Boris
