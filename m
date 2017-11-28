MIME-Version: 1.0
In-Reply-To: <20171128230440.GB28297@mail.hallyn.com>
References: <20171110053757.21170-1-mahesh@bandewar.net> <20171126064037.GB30279@mail.hallyn.com>
 <CAF2d9jhiZFiFODNXUY13F+4Pm+59+rZW=CnLPX1VUT3BAJdeeA@mail.gmail.com> <20171128230440.GB28297@mail.hallyn.com>
From: =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= <maheshb@google.com>
Date: Tue, 28 Nov 2017 15:50:48 -0800
Message-ID: <CAF2d9jhCDasnf2tbaGA04MV5ygZ9o1FaVRCEU2TkHjZR7d1ifw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCHv2 2/2] userns: control capabilities of some user namespaces
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Mahesh Bandewar <mahesh@bandewar.net>, LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>, Kernel-hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Eric W . Biederman" <ebiederm@xmission.com>, Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 28, 2017 at 3:04 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
> Quoting Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=E0=A5=87=E0=A4=B6 =E0=A4=AC=
=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=A4=B0) (maheshb@google.com=
):
> ...
>> >> diff --git a/security/commoncap.c b/security/commoncap.c
>> >> index fc46f5b85251..89103f16ac37 100644
>> >> --- a/security/commoncap.c
>> >> +++ b/security/commoncap.c
>> >> @@ -73,6 +73,14 @@ int cap_capable(const struct cred *cred, struct us=
er_namespace *targ_ns,
>> >>  {
>> >>       struct user_namespace *ns =3D targ_ns;
>> >>
>> >> +     /* If the capability is controlled and user-ns that process
>> >> +      * belongs-to is 'controlled' then return EPERM and no need
>> >> +      * to check the user-ns hierarchy.
>> >> +      */
>> >> +     if (is_user_ns_controlled(cred->user_ns) &&
>> >> +         is_capability_controlled(cap))
>> >> +             return -EPERM;
>> >
>> > I'd be curious to see the performance impact on this on a regular
>> > workload (kernel build?) in a controlled ns.
>> >
>> Should it affect? If at all, it should be +ve since, the recursive
>> user-ns hierarchy lookup is avoided with the above check if the
>> capability is controlled.
>
> Yes but I expect that to be the rare case for normal lxc installs
> (which are of course what I am interested in)
>
>>  The additional cost otherwise is this check
>> per cap_capable() call.
>
> And pipeline refetching?
>
> Capability calls also shouldn't be all that frequent, but still I'm
> left wondering...

Correct, and capability checks are part of the control-path and not
the data-path so shouldn't matter but I guess it doesn't hurt to
find-out the number. Do you have any workload in mind, that we can use
for this test/benchmark?
