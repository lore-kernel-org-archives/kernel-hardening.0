MIME-Version: 1.0
In-Reply-To: <ARSpoDx2fffI86-jLgtoDl0FAjcdXuQ5baKGiHWJXZJq4bJdxv8MXVWhtWlPkToi7VG7bPPMTeD-DWeX9IVXc3MXb93aThPhTJ_xRuDCPHI=@protonmail.com>
References: <s-RLZ9Rez7ayjezQ5oIB5j2qnFqI2e7U7CQf9iGc882wCJB0ZBY7O3xqUyjgqkt3tIthstuRtaPsV_iombyZBru2qIZyjWPyDP7Xj7j9_cQ=@protonmail.com>
 <20170717150110.GA32089@kroah.com> <1WzwohmrS5BCBWVRHghDWZLcRvSX1dfUVqv_EAukcB1RdMdq-KUG6jjVFSQVaR1iWKToJORgS7yUXKg6JhR_n0zRILrxvKqoIIOwKbC_b_8=@protonmail.com>
 <CA+rthh8rBse+W_n80y2V48pK-LsiwSZj-Ysq1=RrTA4jyWwo7g@mail.gmail.com> <ARSpoDx2fffI86-jLgtoDl0FAjcdXuQ5baKGiHWJXZJq4bJdxv8MXVWhtWlPkToi7VG7bPPMTeD-DWeX9IVXc3MXb93aThPhTJ_xRuDCPHI=@protonmail.com>
From: Mathias Krause <minipli@googlemail.com>
Date: Wed, 19 Jul 2017 10:30:43 +0200
Message-ID: <CA+rthh9fhZCPL7kKxbpewewQw9ziNg_RxLLDvUbYuB_QZAAZBg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: Re : Re: [kernel-hardening] Re : Re: Compilation error and
 probable exploit
To: Cleric John Preston <Cleric.John.Preston@protonmail.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "keescook@chromium.org" <keescook@chromium.org>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 19 July 2017 at 08:23, Cleric John Preston
<Cleric.John.Preston@protonmail.com> wrote:
> OK but otherwise
>
> linux-4.13-rc1$ grep "warning:" file | grep "uninitialized"
> drivers/net/wireless/wl3501_cs.c:665:9: warning: =E2=80=98sig.status=E2=
=80=99 is used uninitialized in this function [-Wuninitialized]
> drivers/net/wireless/wl3501_cs.c:668:12: warning: =E2=80=98sig.cap_info=
=E2=80=99 may be used uninitialized in this function [-Wmaybe-uninitialized=
]
> drivers/net/wireless/wl3501_cs.c:670:12: warning: =E2=80=98sig.cap_info=
=E2=80=99 may be used uninitialized in this function [-Wmaybe-uninitialized=
]
> ./include/linux/etherdevice.h:321:39: warning: =E2=80=98*((void *)&sig+29=
)=E2=80=99 may be used uninitialized in this function [-Wmaybe-uninitialize=
d]
> ./include/linux/etherdevice.h:322:38: warning: =E2=80=98*((void *)&sig+33=
)=E2=80=99 may be used uninitialized in this function [-Wmaybe-uninitialize=
d]
> drivers/net/wireless/wl3501_cs.c:677:46: warning: =E2=80=98sig.ssid.el.le=
n=E2=80=99 may be used uninitialized in this function [-Wmaybe-uninitialize=
d]

False positive from what I can tell as gcc apparently cannot deduce
that the insb() in wl3501_get_from_wla() will fill 'sig' completely,
i.e. will initialize it.

Cheers,
Mathias
