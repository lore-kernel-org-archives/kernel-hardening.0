Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: penberg@gmail.com
In-Reply-To: <20110918170512.GA2351@albatros>
References: <20110910164001.GA2342@albatros>
	<20110910164134.GA2442@albatros>
	<20110914192744.GC4529@outflux.net>
	<20110918170512.GA2351@albatros>
Date: Mon, 19 Sep 2011 17:30:49 +0300
Message-ID: <CAOJsxLF8DBEC9o9pSwa6c6pMg8ByFBdsDnzg22P3ucQcP98uzA@mail.gmail.com>
From: Pekka Enberg <penberg@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: Re: [kernel-hardening] Re: [RFC PATCH 2/2] mm: restrict access to /proc/slabinfo
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, kernel-hardening@lists.openwall.com, Kees Cook <kees@ubuntu.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, Christoph Lameter <cl@linux-foundation.org>, Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Dan Rosenberg <drosenberg@vsecurity.com>, Theodore Tso <tytso@mit.edu>, Alan Cox <alan@linux.intel.com>, Jesper Juhl <jj@chaosbits.net>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

> On Wed, Sep 14, 2011 at 12:27 -0700, Kees Cook wrote:
>> On Sat, Sep 10, 2011 at 08:41:34PM +0400, Vasiliy Kulikov wrote:
>> > Historically /proc/slabinfo has 0444 permissions and is accessible to
>> > the world. =A0slabinfo contains rather private information related bot=
h to
>> > the kernel and userspace tasks. =A0Depending on the situation, it migh=
t
>> > reveal either private information per se or information useful to make
>> > another targeted attack. =A0Some examples of what can be learned by
>> > reading/watching for /proc/slabinfo entries:
>> > ...
>> > World readable slabinfo simplifies kernel developers' job of debugging
>> > kernel bugs (e.g. memleaks), but I believe it does more harm than
>> > benefits. =A0For most users 0444 slabinfo is an unreasonable attack ve=
ctor.
>> >
>> > Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>

On Sun, Sep 18, 2011 at 8:05 PM, Vasiliy Kulikov <segoon@openwall.com> wrot=
e:
>> Haven't had any mass complaints about the 0400 in Ubuntu (sorry Dave!), =
so
>> I'm obviously for it.
>>
>> Reviewed-by: Kees Cook <kees@ubuntu.com>
>
> Looks like the members of the previous slabinfo discussion don't object
> against the patch now and it got two other Reviewed-by responses. =A0Can
> you merge it as-is or should I probably convince someone else?

We discussed this in March (google for 'Make /proc/slabinfo 0400') and
concluded that it's not worth it doesn't really protect from anything
and causes harm to developers.

                        Pekka
