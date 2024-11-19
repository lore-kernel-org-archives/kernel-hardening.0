Return-Path: <kernel-hardening-return-21863-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id D70F5D6C281
	for <kernel-hardening@archiver.kernel.org>; Tue, 19 Nov 2024 18:51:58 +0000 (UTC)
Received: (qmail 24471 invoked by uid 550); 19 Nov 2024 18:51:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24451 invoked from network); 19 Nov 2024 18:51:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=89rXTlyvwZf7wy1AENCo71hFPFgxU7iIh40Yvq9+ziw=; b=EvgMhu7TluBgBeWrE8nDe71+fU
	A9TW71iacELiK7rlvJ+FONkzEyTxhuiOuOojwE55G0XCDYerbTnkDeLl21TLOOs+2Zv5qZrdn+wAK
	S2LNeIqWba4oXI3yV/0S2u79Hv5T5bi8jccGMw09kFvwWR1domGUK5TDPKA+3wRRWKtn6GqbJlS+f
	0vJTptsx3NpYYq/f1skl8VjkAZC5xpCI68xYV1zdM8Wkq9WZ4m59YG4Jh2/Ae88RhgFXOi9f2xEQ1
	+iT6gbvy7MPbJUG16lAJlFSsgkL3qzyp/Z0Spi/lcuKDtoAGlwrPDbLeV7s0TcUOdQr85sqRgXOrI
	YVUCngYQ==;
Date: Tue, 19 Nov 2024 18:51:23 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Jann Horn <jannh@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org,
	akpm@linux-foundation.org, corbet@lwn.net, derek.kiernan@amd.com,
	dragan.cvetic@amd.com, arnd@arndb.de, gregkh@linuxfoundation.org,
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	tj@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, Liam.Howlett@oracle.com, vbabka@suse.cz,
	shuah@kernel.org, vegard.nossum@oracle.com, vattunuru@marvell.com,
	schalla@marvell.com, david@redhat.com, osalvador@suse.de,
	usama.anjum@collabora.com, andrii@kernel.org, ryan.roberts@arm.com,
	peterx@redhat.com, oleg@redhat.com, tandersen@netflix.com,
	rientjes@google.com, gthelen@google.com,
	linux-hardening@vger.kernel.org,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: [RFCv1 0/6] Page Detective
Message-ID: <ZzzeK8Fi_GlXPzjc@casper.infradead.org>
References: <20241116175922.3265872-1-pasha.tatashin@soleen.com>
 <a0372f7f-9a85-4d3e-ba20-b5911a8189e3@lucifer.local>
 <CAG48ez2vG0tr=H8csGes7HN_5HPQAh4WZU8U1G945K1GKfABPg@mail.gmail.com>
 <CA+CK2bB0w=i1z78AJbr2gZE9ybYki4Vz_s53=8URrxwyPvvB+A@mail.gmail.com>
 <CAG48ez1KFFXzy5qcYVZLnUEztaZxDGY2+4GvwYq7Hb=Y=3FBxQ@mail.gmail.com>
 <CA+CK2bCBwZFomepG-Pp6oiAwHQiKdsTLe3rYtE3hFSQ5spEDww@mail.gmail.com>
 <CAG48ez0NzMbwnbvMO7KbUROZq5ne7fhiau49v7oyxwPrYL=P6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez0NzMbwnbvMO7KbUROZq5ne7fhiau49v7oyxwPrYL=P6Q@mail.gmail.com>

On Tue, Nov 19, 2024 at 01:52:00PM +0100, Jann Horn wrote:
> > I will take reference, as we already do that for memcg purpose, but
> > have not included dump_page().
> 
> Note that taking a reference on the page does not make all of
> dump_page() fine; in particular, my understanding is that
> folio_mapping() requires that the page is locked in order to return a
> stable pointer, and some of the code in dump_mapping() would probably
> also require some other locks - probably at least on the inode and
> maybe also on the dentry, I think? Otherwise the inode's dentry list
> can probably change concurrently, and the dentry's name pointer can
> change too.

First important thing is that we snapshot the page.  So while we may
have a torn snapshot of the page, it can't change under us any more,
so we don't have to worry about it being swizzled one way and then
swizzled back.

Second thing is that I think using folio_mapping() is actually wrong.
We don't want the swap mapping if it's an anon page that's in the
swapcache.  We'd be fine just doing mapping = folio->mapping (we'd need
to add a check for movable, but I think that's fine).  Anyway, we know
the folio isn't ksm or anon at the point that we call dump_mapping()
because there's a chain of "else" statements.  So I think we're fine
because we can't switch between anon & file while holding a refcount.

Having a refcount on the folio will prevent the folio from being allocated
to anything else again.  It will not protect the mapping from being torn
down (the folio can be truncated from the mapping, then the mapping can
be freed, and the memory reused).  As you say, the dentry can be renamed
as well.

This patch series makes me nervous.  I'd rather see it done as a bpf
script or drgn script, but if it is going to be done in C, I'd really
like to see more auditing of the safety here.  It feels like the kind
of hack that one deploys internally to debug a hard-to-hit condition,
rather than the kind of code that we like to ship upstream.
