MIME-Version: 1.0
In-Reply-To: <20171110043010.GA3572@mail.hallyn.com>
References: <20171103004433.39954-1-mahesh@bandewar.net> <20171109172201.GA26229@mail.hallyn.com>
 <CAF2d9jhCbZA2J1WCc5MNUssiNSNeP5J8i9VNUETKBGhM4X4t8Q@mail.gmail.com> <20171110043010.GA3572@mail.hallyn.com>
From: =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= <maheshb@google.com>
Date: Fri, 10 Nov 2017 14:05:51 +0900
Message-ID: <CAF2d9ji6wcxd_q60GZ-auLB9CFWqSaV2=j4waDJWOu-rVdR5NA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH resend 1/2] capability: introduce sysctl for controlled
 user-ns capability whitelist
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Mahesh Bandewar <mahesh@bandewar.net>, LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>, Kernel-hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Eric W . Biederman" <ebiederm@xmission.com>, Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Nov 10, 2017 at 1:30 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
> Quoting Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=E0=A5=87=E0=A4=B6 =E0=A4=AC=
=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=A4=B0) (maheshb@google.com=
):
> ...
>> >>
>> >>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> >>
>> >> +controlled_userns_caps_whitelist
>> >> +
>> >> +Capability mask that is whitelisted for "controlled" user namespaces=
.
>> >> +Any capability that is missing from this mask will not be allowed to
>> >> +any process that is attached to a controlled-userns. e.g. if CAP_NET=
_RAW
>> >> +is not part of this mask, then processes running inside any controll=
ed
>> >> +userns's will not be allowed to perform action that needs CAP_NET_RA=
W
>> >> +capability. However, processes that are attached to a parent user-ns
>> >> +hierarchy that is *not* controlled and has CAP_NET_RAW can continue
>> >> +performing those actions. User-namespaces are marked "controlled" at
>> >> +the time of their creation based on the capabilities of the creator.
>> >> +A process that does not have CAP_SYS_ADMIN will create user-namespac=
es
>> >> +that are controlled.
>> >
>> > Hm.  I think that's fine (the way 'controlled' user namespaces are
>> > defined), but that is design decision in itself, and should perhaps be
>> > discussed.
>> >
>> > Did you consider other ways?  What about using CAP_SETPCAP?
>> >
>> I did try other ways e.g. using another bounding-set etc. but
>> eventually settled with this approach because of main two properties -
>
> No, I meant did you try other ways of defining a controlled user
> namespace, other than one which is created by a task lacking
> CAP_SYS_ADMIN?
>
SYS_ADMIN is the capability that has been used for deciding who can or
cannot create namespaces, so didn't want to create another model that
may not be compatible with current model which is well understood
hence no.

> ...
>
>> >> +The value is expressed as two comma separated hex words (u32). This
>> >
>> > Why comma separated?  whitespace ok?  Leading 0x ok?  What is the
>> > default at boot?  (Obviously the patch tells me, I'm asking for it
>> > to be spelled out in the doc)
>> >
>> I tried multiple ways including representing capabilities in
>> string/name form for better readability but didn't want to add
>> additional complexities of dealing with strings and possible
>> string-related-issues for this. Also didn't want to reinvent the new
>> form so settled with something that is widely used (cpu
>> bounding/affinity/irq mapping etc.) and is capable of handling growing
>> bit set (currently 37 but possibly more later).
>
> Ok, thanks.
