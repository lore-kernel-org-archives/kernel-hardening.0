MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170528081541.GE22193@infradead.org>
References: <1495829844-69341-1-git-send-email-keescook@chromium.org>
 <1495829844-69341-9-git-send-email-keescook@chromium.org> <20170528081541.GE22193@infradead.org>
From: Kees Cook <keescook@chromium.org>
Date: Sun, 28 May 2017 10:37:26 -0700
Message-ID: <CAGXu5jKYHVWUnLpMn4Ef9S=0hCX-hh0h_UGuV7+a_jz5v68mFQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH v2 08/20] randstruct: Whitelist NIU struct page overloading
To: Christoph Hellwig <hch@infradead.org>, Linux-MM <linux-mm@kvack.org>, Network Development <netdev@vger.kernel.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "David S . Miller" <davem@davemloft.net>, Laura Abbott <labbott@redhat.com>, "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

[trying again with correct linux-mm address...]

On Sun, May 28, 2017 at 1:15 AM, Christoph Hellwig <hch@infradead.org> wrot=
e:
> On Fri, May 26, 2017 at 01:17:12PM -0700, Kees Cook wrote:
>> The NIU ethernet driver intentionally stores a page struct pointer on
>> top of the "mapping" field. Whitelist this case:
>>
>> drivers/net/ethernet/sun/niu.c: In function =E2=80=98niu_rx_pkt_ignore=
=E2=80=99:
>> drivers/net/ethernet/sun/niu.c:3402:10: note: found mismatched ssa struc=
t pointer types: =E2=80=98struct page=E2=80=99 and =E2=80=98struct address_=
space=E2=80=99
>>
>>     *link =3D (struct page *) page->mapping;
>>     ~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>
>> Cc: David S. Miller <davem@davemloft.net>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>
> The driver really needs to stop doing this anyway.  It would be good
> to send this out to linux-mm and netdev to come up with a better scheme.

Added to To. :) I couldn't understand why it was doing what it was
doing, hence the whitelist entry.

-Kees

--=20
Kees Cook
Pixel Security
