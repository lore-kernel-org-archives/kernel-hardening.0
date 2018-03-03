Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Subject: Re: [RFC PATCH] Randomization of address chosen by mmap.
From: Ilya Smith <blackzert@gmail.com>
In-Reply-To: <20180302204808.GA671@bombadil.infradead.org>
Date: Sat, 3 Mar 2018 18:13:28 +0300
Content-Transfer-Encoding: quoted-printable
Message-Id: <221A2345-53FF-4471-B4FA-C79AF90B70CE@gmail.com>
References: <20180227131338.3699-1-blackzert@gmail.com>
 <CAGXu5jKF7ysJqj57ZktrcVL4G2NWOFHCud8dtXFHLs=tvVLXnQ@mail.gmail.com>
 <55C92196-5398-4C19-B7A7-6C122CD78F32@gmail.com>
 <20180228183349.GA16336@bombadil.infradead.org>
 <C9D0E3BA-3AB9-4F0E-BDA5-32378E440986@gmail.com>
 <20180302204808.GA671@bombadil.infradead.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Michal Hocko <mhocko@suse.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Jan Kara <jack@suse.cz>, Jerome Glisse <jglisse@redhat.com>, Hugh Dickins <hughd@google.com>, Helge Deller <deller@gmx.de>, Andrea Arcangeli <aarcange@redhat.com>, Oleg Nesterov <oleg@redhat.com>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

> On 2 Mar 2018, at 23:48, Matthew Wilcox <willy@infradead.org> wrote:
> Ah, I didn't mean that.  I was thinking that we can change the
> implementation to reserve 1-N pages after the end of the mapping.
> So you can't map anything else in there, and any load/store into that
> region will segfault.
>=20

I=E2=80=99m afraid it still will allow many attacks. The formula for new =
address would=20
be like: address_next =3D address_prev - mmap_size - random(N) as you =
suggested.=20
To prevent brute-force attacks N should be big enough  like more 2^32 =
for=20
example. This number 2^32 is just an example and right now I don=E2=80=99t=
 know the=20
exact value. What I=E2=80=99m trying to say that address computation =
formula has=20
dependency on concrete predictable address. In my scheme even =
address_prev was=20
chose randomly.=20

Best regards,
Ilya
