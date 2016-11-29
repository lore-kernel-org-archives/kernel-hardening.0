Reply-To: kernel-hardening@lists.openwall.com
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41C190FC@IRSMSX102.ger.corp.intel.com>
References: <2236FBA76BA1254E88B949DDB74E612B41C1884B@IRSMSX102.ger.corp.intel.com> <20161128121347.GY3092@twins.programming.kicks-ass.net> <2236FBA76BA1254E88B949DDB74E612B41C190FC@IRSMSX102.ger.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
From: Peter Zijlstra <peterz@infradead.org>
Date: Tue, 29 Nov 2016 16:47:11 +0100
Message-ID: <445CCB78-B113-4B85-B254-B27E588A9EE6@infradead.org>
Subject: [kernel-hardening] RE: Conversion from atomic_t to refcount_t: summary of issues
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Greg KH <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, "will.deacon@arm.com" <will.deacon@arm.com>, Boqun Feng <boqun.feng@gmail.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, "aik@ozlabs.ru" <aik@ozlabs.ru>, "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
List-ID: <kernel-hardening.lists.openwall.com>



On 29 November 2016 16:35:15 CET, "Reshetova, Elena" <elena.reshetova@intel.com> wrote:
>So, could we agree on the following additions that are needed to
>refcount_t API:
>
>- refcount_long_t and all related functions
>- refcount_add(), refcount_sub(), refcount_sub_and_test()
>- refcount_dec_return(), refcount_inc_return()
>- refcount_dec_if_one()
>
>With the above set we can hopefully convert almost everything we
>already saw and then we can decide what to do with remaining extreme
>cases. 
>
>Peter, if you would be able to send the new patch providing the above
>API, it would be great!

I'm not convinced on the return variants. I'll have to look at a number of usage sites to determine wth  they're doing. (Or someone else needs to and explain it here)

Also, I'm ill atm, so I'm not particularly productive.

Also, it would be very good to hear other opinions on the add/sub thing, last time they came up tglx in particular hated them.
-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity.
