Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41BF9AD4@IRSMSX102.ger.corp.intel.com>
References: <1476959131-6153-1-git-send-email-elena.reshetova@intel.com>
 <20161020131350.GA18331@thigreal> <CAGXu5jK1MNzM5Qi8o+HHekWm38n-WVPQ1Q3_EPpjYqE0kk8X0w@mail.gmail.com>
 <20161025090559.eqsll3d7y2ifdaug@thigreal> <1477415895.2263.43.camel@cvidal.org>
 <CAEXv5_jk+2KOxL9UdZ5+6B8+JV2CBtNGi65a7ddtvxwUGmnPkA@mail.gmail.com>
 <1477428836.2263.70.camel@cvidal.org> <2236FBA76BA1254E88B949DDB74E612B41BF8C68@IRSMSX102.ger.corp.intel.com>
 <1477471489.2263.107.camel@cvidal.org> <2236FBA76BA1254E88B949DDB74E612B41BF8D57@IRSMSX102.ger.corp.intel.com>
 <1477507968.2263.125.camel@cvidal.org> <1477511274.2263.135.camel@cvidal.org>
 <CAGXu5j+N8cm=4Wu8EmqXrEYXj-P4GwJX3fmKMcUM27zjEy+dig@mail.gmail.com>
 <1477512469.2263.141.camel@cvidal.org> <2236FBA76BA1254E88B949DDB74E612B41BF9479@IRSMSX102.ger.corp.intel.com>
 <CAEXv5_jDAPAqHp7vfOzU+WqN_h3g00_VUOz2_xxp9nJNzzFjxg@mail.gmail.com>
 <CAEXv5_izCpFQ39SGL_CD9J2A5XD1TVNJm8C3S+a3TuyriLcbJQ@mail.gmail.com> <2236FBA76BA1254E88B949DDB74E612B41BF9AD4@IRSMSX102.ger.corp.intel.com>
From: David Windsor <dwindsor@gmail.com>
Date: Fri, 28 Oct 2016 11:20:33 -0400
Message-ID: <CAEXv5_g1VEWY9yEnbSihiCxBJYENCJDmitFJ66ihPwO5eNzLog@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [RFC v2 PATCH 00/13] HARDENED_ATOMIC
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Hans Liljestrand <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Done.  I added a line to the "HARDENED_ATOMIC Implementation" section
of Documentation/security/hardened-atomic.txt describing the results
of the benchmarks (no measurable performance difference).  You might
want to add this line to the cover letter as well.

I know I promised to post the results of another set of benchmarks I
performed, and I will do that soon.

Thanks,
David

On Fri, Oct 28, 2016 at 9:02 AM, Reshetova, Elena
<elena.reshetova@intel.com> wrote:
>>> - add missing tests for atomic64 and local
>>> - rebase on top of latest linux-next
>>> - compile test and test run the whole thing in different combinations
>>> - send rfcv3 with also all atomic maintainers included for wider
>>> blame/feedback
>>>
>>> Does it sound like a good plan for everyone?
>>>
>
>> Actually, it doesn't look like I've updated Documentation/security/hardened-atomic.txt yet.  I need to fix the language explaining the x86 race condition to make it clear that we're discussing the SMP case.
>> I also want to add a sentence somewhere (either in your cover letter or in the kernel documentation, or both), referencing the benchmark results and lack of demonstrable performance degradation.
>
> David, could you please push the changes you want to do to the documentation in separate commit to the top of hardened_atomic_on_next?
>  I will cherry pick them to our new rebased branch hardened_atomic_next that we still working actively now.
>
> Best Regards,
> Elena.
