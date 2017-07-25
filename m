Sender: Hans Liljestrand <ishkamiel@gmail.com>
Date: Tue, 25 Jul 2017 10:52:17 +0300
From: Hans Liljestrand <liljestrandh@gmail.com>
Message-ID: <20170725075217.bfwp7slacegqcv7g@ishxps>
References: <20170724133824.27223-1-LiljestrandH@gmail.com>
 <20170724133824.27223-4-LiljestrandH@gmail.com>
 <CAGXu5jKLFoF584WMYG2CEaON-RSV6TjEzVJtvbuT1ahs0ER6cw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAGXu5jKLFoF584WMYG2CEaON-RSV6TjEzVJtvbuT1ahs0ER6cw@mail.gmail.com>
Subject: [kernel-hardening] Re: [RFC PATCH 3/5] x86: add mpxk-wrappers
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Reshetova, Elena" <elena.reshetova@intel.com>, Dave Hansen <dave.hansen@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Daniel Micay <danielmicay@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jul 24, 2017 at 07:45:21PM -0700, Kees Cook wrote:
>On Mon, Jul 24, 2017 at 6:38 AM, Hans Liljestrand
><liljestrandh@gmail.com> wrote:
>> This adds actual implementation for mpxk-wrapper functions. The wrapper
>> function are used by the instrumentation to update and check pointer bounds
>> on functions that alter memory, e.g. kmalloc and memcpy. The kmalloc
>> wrapper function for instance simply executes kmalloc, associates bounds
>> with the returned pointer, and returns both. Other wrapper functions, such
>> as for memcpy, also check the bounds of incoming arguments.
>>
>> For future work these wrappers could potentially be replaced by direct
>> instrumentation without the need to incur the cost of calling the wrapper
>> function. In this scenario every kmalloc would simply be preceded by an
>> appropriate mkbnd instruction, and memcpy preceded by bndcu+bndcl
>> instructions.
>>
>> The wrappers are added by the MPXK gcc-plugin, and as such work on
>> preprocessed code. This introduces another problem with our
>> implementation since macros might actually be used to direct "base
>> functions" into specific implementations (e.g. memcpy might be a macro
>> pointing to __memcpy). One solution is covering all possibilities, but
>> this might introduce unwanted code bloat.
>
>I'd be curious to see how (if?) this interacts with CONFIG_FORTIFY. It
>seems that currently the MPXK checks would be similar to the
>inter-object checks as they exist (e.g. checking the size of the whole
>kmalloc allocation), but it wouldn't work on intra-object copies (i.e.
>bounds checking a field within an object).

Do you mean the FORTIFY_SOURCE thing (could not find anything directly on 
CONFIG_FORTIFY). Based on a quick look FORTIFY_SOURCE is localized, and 
essentially just provides the equivalent os our "wrappers", but I could be 
wildly off?

MPXK on the other hand also checks other pointer dereferences and propagates 
pointer bounds into non-wrapper functions. The wrappers themselves also do not 
load any bounds, instead the calling function passes in the pointer bounds via 
the bound registers (although the caller might, depending on the situation 
have loaded the bounds based on the kmalloc allocation).

Regarding inter-objects thing MPXK is a bit fuzzy, which is one of the 
weaknesses of our approach in general. The mpxk_load_bounds functions uses the 
whole kmalloc allocation, but MPX also uses narrowing, which (in some cases) 
narrows pointer bounds to intra-object pointers (excluding first fields and 
pointers into arrays, which all retain the bounds of the whole structure). The 
narrowing is provided by vanilla GCC MPX instrumentation, not specific to our 
MPXK code. As a guarantee we therefore cannot say more than that we enforce 
the whole kmalloc area (provided kmalloc was used).

>
>More directly, I'd be curious to see coverage and performance
>comparisons between FORTIFY and MPXK.

Based on the above we have seen KASAN as the more direct comparison, or would 
you disagree? In the any case, we would also like to get some actual 
comparisons done. 

Can you recommend any "standard" way of doing measurements, either coverage or 
performance, for this kind of protections?

Thanks,
-hans

>
>-Kees
>
>-- 
>Kees Cook
>Pixel Security
