Reply-To: kernel-hardening@lists.openwall.com
References: <58061416.7020209@oracle.com>
 <CAGXu5jJU0rtzyYbmv7x=GJF2c8rmW2MyZaSDn_+U94PjkmT_tg@mail.gmail.com>
From: Vaishali Thakkar <vaishali.thakkar@oracle.com>
Message-ID: <580DB4B4.4060607@oracle.com>
Date: Mon, 24 Oct 2016 12:43:56 +0530
MIME-Version: 1.0
In-Reply-To: <CAGXu5jJU0rtzyYbmv7x=GJF2c8rmW2MyZaSDn_+U94PjkmT_tg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Use-after-free and management of reference
 counts
To: kernel-hardening@lists.openwall.com
Cc: Julia Lawall <julia.lawall@lip6.fr>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>



On Wednesday 19 October 2016 03:06 AM, Kees Cook wrote:
> On Tue, Oct 18, 2016 at 5:22 AM, Vaishali Thakkar
> <vaishali.thakkar@oracle.com> wrote:
>> Hi,
>>
>> Recently I studied the reported CVEs of last 2 years and there were
>> fair number of use-after-free bugs. Usually we also see many reports
>> of use-after-free bugs in the LKML [reported by one or other tools].
>>
>> Also, at Kernel recipes Jonathan Corbet  mentioned reference counts as
>> a security issue. I believe if we have more kernel hardening patches
>> then we can avoid such bugs. I was wondering if there is some ongoing
>> work in the both [use-after-free and management of reference counts]
>> of these areas?
>>
>> If not, then I would like to work on the same. Any pointers on this
>> would be appreciated.
> 
> Others have already mentioned the HARDENED_ATOMIC work that is
> underway, but one place I'd really like to take a little bit more time
> to examine is how to improve the zero-poisoning work that Laura Abbott
> did recently. Having this feature reduces the availability of a subset
> of kernel memory exposures and can frustrate a subset of
> use-after-free exploits. It's been in the kernel since v4.6, but it
> needs some performance tuning and likely some other adjustments. I
> talk about it a bit here:

Hi,

Sorry, I missed this as I was not CC'ed. Thanks for the pointers.

> https://outflux.net/blog/archives/2016/09/30/security-things-in-linux-v4-6/
> 
> I think to really dial in this protection so it is more like
> PAX_MEMORY_SANITIZE, we'd need to do the following:
> 
> - adjust the slab poisoning to do zeroing (upstream's slab poisoning
> uses a different value)
> - consolidate the CONFIG and run-time cmdlines to give us a single "do
> the right thing" CONFIG
> - identify frequently-freed slabs that are less security-sensitive and
> whitelist them from the poisoning (as done by PAX_MEMORY_SANITIZE)
> - add kernel command-line argument to control poisoning (as done by
> PAX_MEMORY_SANITIZE)

I am looking in to the work done by Laura and PAX team. I'll get back to you
on this soon.

> -Kees
> 

-- 
Vaishali
