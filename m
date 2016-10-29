Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41BF9F9E@IRSMSX102.ger.corp.intel.com>
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
 <CAEXv5_izCpFQ39SGL_CD9J2A5XD1TVNJm8C3S+a3TuyriLcbJQ@mail.gmail.com>
 <2236FBA76BA1254E88B949DDB74E612B41BF9AD4@IRSMSX102.ger.corp.intel.com>
 <CAEXv5_g1VEWY9yEnbSihiCxBJYENCJDmitFJ66ihPwO5eNzLog@mail.gmail.com> <2236FBA76BA1254E88B949DDB74E612B41BF9F9E@IRSMSX102.ger.corp.intel.com>
From: David Windsor <dave@progbits.org>
Date: Sat, 29 Oct 2016 07:48:00 -0400
Message-ID: <CAEXv5_g4xSAX3U7hXhAObWuwWDvy4WnuCR55QH_JhgqJcVvFgg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [kernel-hardening] [RFC v2 PATCH 00/13] HARDENED_ATOMIC
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Hans Liljestrand <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Oct 29, 2016 at 6:31 AM, Reshetova, Elena
<elena.reshetova@intel.com> wrote:
>
>>Done.  I added a line to the "HARDENED_ATOMIC Implementation" section of =
Documentation/security/hardened-atomic.txt describing the results of the be=
nchmarks (no measurable performance difference).  You might want to add thi=
s line to the cover >letter as well.
>
> Oh, one more thing. David you were planning to change a bit the wording o=
n the racing issue in the documentation. Could you please still do it? Woul=
d be great to fix that before sending next rfc.
>

Ah yes, I forgot about this, sorry!  I just updated the language in
Documentation/security/hardened-atomic.txt to include a line
indicating that the x86 race is only reachable in SMP conditions.

I push --force'd the change to hardened_atomic_next.

> @everyone: Now I finally cleaned up and repo and deleted all unneeded bra=
nches. The main working branch is *hardened_atomic_next* now (based on linu=
x-next stable branch)
>
> Best Regards,
> Elena.
