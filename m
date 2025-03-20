Return-Path: <kernel-hardening-return-21952-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 009CEC28B30
	for <kernel-hardening@archiver.kernel.org>; Thu, 20 Mar 2025 18:50:32 +0000 (UTC)
Received: (qmail 29816 invoked by uid 550); 20 Mar 2025 18:50:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28049 invoked from network); 20 Mar 2025 14:37:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742481455;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q8jQTpgamRT98fNj7lmPmNzbNNmBivJr+9bIgtnjm7g=;
	b=GgEPBbAO/LCyQByiDi827KZk/5N1ICxRiI6JbIVVpPS27s4FoaDJ/n9FsBl0uGYc16qy11
	+tcNgVSWWzm809Thij+JgDwFrcNQPZ30Vk2EkDKAk8LtIE8ollaAmgHSLn4RcJc/urmS89
	Kf8GXW0SXbJwiLBKyQEL4VNpCsCCR80=
X-MC-Unique: OYW5uebkMX2vALcvc8zwaw-1
X-Mimecast-MFC-AGG-ID: OYW5uebkMX2vALcvc8zwaw_1742481452
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742481452; x=1743086252;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZLx6gnmmSWWfdNgPfLYTsxSrV+Ix7KpS1F+U6ftX2nU=;
        b=UbsbDzcda/MNRiSe+ymuwoLIddFhgguzGTZBc8A/mI59IKku1OXG4FtkyT00VIiSD3
         D9x85t+UTXUALOv+Vs3EbFgeJOASWQSZbEUXr+3qTGamP2VUUfwMVHdLLpibIDqrgD63
         UOrdZxFiMAqKonrR5h+N78LEQSU3t45/Tw4+UksUZCrCeKHWT/hMnqDZcIYasxZTc5HJ
         hvJ7Tm7hOVO0kMoCyF8QQ90Roz6fgLvKhvLpVDyHNomw6QS4SDuM33kNR91uKRGqzjSg
         Rzlc873w1u7lbL6ab9EPIoEzBliNL5AHhPng/J0TvLRocyP73q35gRAXk1JBuVgXgjh2
         uyIw==
X-Forwarded-Encrypted: i=1; AJvYcCXSjfjCCtHENYl78rSgiKaOqHfb069hOaPbjPNs77O2yVwOdpLMpdK5kFZkQDENW2S6zSQ46fcomMHlCByltOD4@lists.openwall.com
X-Gm-Message-State: AOJu0Yyo995Xr1HSUEGRLjCghvn1jXm1zeqoQ8Ujd2vt4+9BCd+YMgkF
	YxPnuiWA0CKbLS7R8Z1fsnELm2XD2lAkJUYSnQEKzQbXxXUOVDU7hBUhIBvHpI5nmTSP9pnwkEq
	ZmirhcvPfzY67qazxChbOyAh94nvH21HEFlUjX5aD3y34uct7e5T03W9fYkaasIIuthdMr3M=
X-Gm-Gg: ASbGnctoD609cWFgRZYsjbW0HPTtg/1ZydS/ToUoxp/Bl5Ojqq49K0HmKkakyxOE9oT
	DTmszn0jNS6jWaccrimOZZ4hqGY2wjz9BsHnTawAyKbKzW6V0dxxWhlc9jAlqZr/j09826JIJGk
	J+gCaTiZfQzI5LyRrAQo6HLJ+LwVaKIb8GxepDswlUe0mY+ioEKttSxUK9bfAHoWWGmHp9dklLF
	k1L0WUS2qO9y1GyQr7rzcah3SK5rOKRwV0NVYIhbNTQ+f5L0dR9ZEKZoQliOmCMDkGFnRI17ZiE
	YUUR6tLhlCp7
X-Received: by 2002:a05:6512:3f18:b0:549:929c:e896 with SMTP id 2adb3069b0e04-54acfaa1b0emr1518833e87.11.1742481451802;
        Thu, 20 Mar 2025 07:37:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE5VpCfZOFBC54LR922wO7u7GK5UhK0NC/mhGGmpD3DQ8vCNlbhBNi5GGvL7dfWltRcMPHQyg==
X-Received: by 2002:a05:6512:3f18:b0:549:929c:e896 with SMTP id 2adb3069b0e04-54acfaa1b0emr1518818e87.11.1742481451151;
        Thu, 20 Mar 2025 07:37:31 -0700 (PDT)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To: Solar Designer <solar@openwall.com>, Yunsheng Lin <linyunsheng@huawei.com>
Cc: Yunsheng Lin <yunshenglin0825@gmail.com>, "David S. Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Jesper Dangaard
 Brouer <hawk@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>, Leon
 Romanovsky <leon@kernel.org>, Tariq Toukan <tariqt@nvidia.com>, Andrew
 Lunn <andrew+netdev@lunn.ch>, Eric Dumazet <edumazet@google.com>, Paolo
 Abeni <pabeni@redhat.com>, Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Simon Horman <horms@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, Mina Almasry <almasrymina@google.com>,
 Yonglong Liu <liuyonglong@huawei.com>, Pavel Begunkov
 <asml.silence@gmail.com>, Matthew Wilcox <willy@infradead.org>, Robin
 Murphy <robin.murphy@arm.com>, IOMMU <iommu@lists.linux.dev>,
 segoon@openwall.com, kernel-hardening@lists.openwall.com,
 netdev@vger.kernel.org, bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-mm@kvack.org, Qiuling Ren <qren@redhat.com>, Yuying Ma
 <yuma@redhat.com>, sultan@kerneltoast.com
Subject: Re: [PATCH net-next 3/3] page_pool: Track DMA-mapped pages and
 unmap them when destroying the pool
In-Reply-To: <20250320023202.GA25514@openwall.com>
References: <20250314-page-pool-track-dma-v1-0-c212e57a74c2@redhat.com>
 <20250314-page-pool-track-dma-v1-3-c212e57a74c2@redhat.com>
 <db813035-fb38-4fc3-b91e-d1416959db13@gmail.com> <87jz8nhelh.fsf@toke.dk>
 <7a76908d-5be2-43f1-a8e2-03b104165a29@huawei.com> <87wmcmhxdz.fsf@toke.dk>
 <ce6ca18b-0eda-4d62-b1d3-e101fe6dcd4e@huawei.com>
 <20250320023202.GA25514@openwall.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Thu, 20 Mar 2025 15:37:29 +0100
Message-ID: <87ldszix92.fsf@toke.dk>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9QHwAvuzMX4uqEg5VCkPEZY6sMfpNN1ng_yji_xdDoM_1742481452
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Solar Designer <solar@openwall.com> writes:

> On Wed, Mar 19, 2025 at 07:06:57PM +0800, Yunsheng Lin wrote:
>> On 2025/3/19 4:55, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> > Yunsheng Lin <linyunsheng@huawei.com> writes:
>> >> On 2025/3/17 23:16, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> >>> Yunsheng Lin <yunshenglin0825@gmail.com> writes:
>> >>>> On 3/14/2025 6:10 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> >>>>
>> >>>> ...
>> >>>>
>> >>>>> To avoid having to walk the entire xarray on unmap to find the pag=
e
>> >>>>> reference, we stash the ID assigned by xa_alloc() into the page
>> >>>>> structure itself, using the upper bits of the pp_magic field. This
>> >>>>> requires a couple of defines to avoid conflicting with the
>> >>>>> POINTER_POISON_DELTA define, but this is all evaluated at compile-=
time,
>> >>>>> so does not affect run-time performance. The bitmap calculations i=
n this
>> >>>>> patch gives the following number of bits for different architectur=
es:
>> >>>>>
>> >>>>> - 24 bits on 32-bit architectures
>> >>>>> - 21 bits on PPC64 (because of the definition of ILLEGAL_POINTER_V=
ALUE)
>> >>>>> - 32 bits on other 64-bit architectures
>> >>>>
>> >>>>  From commit c07aea3ef4d4 ("mm: add a signature in struct page"):
>> >>>> "The page->signature field is aliased to page->lru.next and
>> >>>> page->compound_head, but it can't be set by mistake because the
>> >>>> signature value is a bad pointer, and can't trigger a false positiv=
e
>> >>>> in PageTail() because the last bit is 0."
>> >>>>
>> >>>> And commit 8a5e5e02fc83 ("include/linux/poison.h: fix LIST_POISON{1=
,2}=20
>> >>>> offset"):
>> >>>> "Poison pointer values should be small enough to find a room in
>> >>>> non-mmap'able/hardly-mmap'able space."
>> >>>>
>> >>>> So the question seems to be:
>> >>>> 1. Is stashing the ID causing page->pp_magic to be in the mmap'able=
/
>> >>>>     easier-mmap'able space? If yes, how can we make sure this will =
not
>> >>>>     cause any security problem?
>> >>>> 2. Is the masking the page->pp_magic causing a valid pionter for
>> >>>>     page->lru.next or page->compound_head to be treated as a vaild
>> >>>>     PP_SIGNATURE? which might cause page_pool to recycle a page not
>> >>>>     allocated via page_pool.
>> >>>
>> >>> Right, so my reasoning for why the defines in this patch works for t=
his
>> >>> is as follows: in both cases we need to make sure that the ID stashe=
d in
>> >>> that field never looks like a valid kernel pointer. For 64-bit arche=
s
>> >>> (where CONFIG_ILLEGAL_POINTER_VALUE), we make sure of this by never
>> >>> writing to any bits that overlap with the illegal value (so that the
>> >>> PP_SIGNATURE written to the field keeps it as an illegal pointer val=
ue).
>> >>> For 32-bit arches, we make sure of this by making sure the top-most =
bit
>> >>> is always 0 (the -1 in the define for _PP_DMA_INDEX_BITS) in the pat=
ch,
>> >>> which puts it outside the range used for kernel pointers (AFAICT).
>> >>
>> >> Is there any season you think only kernel pointer is relevant here?
>> >=20
>> > Yes. Any pointer stored in the same space as pp_magic by other users o=
f
>> > the page will be kernel pointers (as they come from page->lru.next). T=
he
>> > goal of PP_SIGNATURE is to be able to distinguish pages allocated by
>> > page_pool, so we don't accidentally recycle a page from somewhere else=
.
>> > That's the goal of the check in page_pool_page_is_pp():
>> >=20
>> > (page->pp_magic & PP_MAGIC_MASK) =3D=3D PP_SIGNATURE
>> >=20
>> > To achieve this, we must ensure that the check above never returns tru=
e
>> > for any value another page user could have written into the same field
>> > (i.e., into page->lru.next). For 64-bit arches, POISON_POINTER_DELTA
>>=20
>> POISON_POINTER_DELTA is defined according to CONFIG_ILLEGAL_POINTER_VALU=
E,
>> if CONFIG_ILLEGAL_POINTER_VALUE is not defined yet, POISON_POINTER_DELTA
>> is defined to zero.
>>=20
>> It seems only the below 64-bit arches define CONFIG_ILLEGAL_POINTER_VALU=
E
>> through grepping:
>> a29815a333c6 core, x86: make LIST_POISON less deadly
>> 5c178472af24 riscv: define ILLEGAL_POINTER_VALUE for 64bit
>> f6853eb561fb powerpc/64: Define ILLEGAL_POINTER_VALUE for 64-bit
>> bf0c4e047324 arm64: kconfig: Move LIST_POISON to a safe value
>>=20
>> The below 64-bit arches don't seems to define the above config yet:
>> MIPS64, SPARC64, System z(S390X),loongarch
>>=20
>> Does ID stashing cause problem for the above arches?
>>=20
>> > serves this purpose. For 32-bit arches, we can leave the top-most bits
>> > out of PP_MAGIC_MASK, to make sure that any valid pointer value will
>> > fail the check above.
>>=20
>> The above mainly explained how to ensure page_pool_page_is_pp() will
>> not return false positive result from the page_pool perspective.
>>=20
>> From MM/security perspective, most of the commits quoted above seem
>> to suggest that poison pointer should be in the non-mmap'able or
>> hardly-mmap'able space, otherwise userspace can arrange for those
>> pointers to actually be dereferencable, potentially turning an oops
>> to an expolit, more detailed example in the below paper, which explains
>> how to exploit a vulnerability which hardened by the 8a5e5e02fc83 commit=
:
>> https://www.usenix.org/system/files/conference/woot15/woot15-paper-xu.pd=
f
>>=20
>> ID stashing seems to cause page->lru.next (aliased to page->pp_magic) to
>> be in the mmap'able space for some arches.
>
> ...
>
>> To be honest, I am not that familiar with the pointer poison mechanism.
>> But through some researching and analyzing, it makes sense to overstate
>> it a little as it seems to be security-related.
>> Cc'ed some security-related experts and ML to see if there is some
>> clarifying from them.
>
> You're correct that the pointer poison values should be in areas not
> mmap'able by userspace (at least with reasonable mmap_min_addr values).
>
> Looking at the union inside "struct page", I see pp_magic is aliased
> against multiple pointers in the union'ed anonymous structs.
>
> I'm not familiar with the uses of page->pp_magic and how likely or not
> we are to have a bug where its aliasing with pointers would be exposed
> as an attack vector, but this does look like a serious security concern.
> It looks like we would be seriously weakening the poisoning, except on
> archs where the new values with ID stashing are still not mmap'able.
>
> I just discussed the matter with my colleague at CIQ, Sultan Alsawaf,
> and he thinks the added risk is not that bad.  He wrote:
>
>> Toke's response here is fair:
>>=20
>> > Right, okay, I see what you mean. So the risk is basically the
>> > following:
>> >=20
>> > If some other part of the kernel ends up dereferencing the
>> > page->lru.next pointer of a page that is owned by page_pool, and which
>> > has an ID stashed into page->pp_magic, that dereference can end up bei=
ng
>> > to a valid userspace mapping, which can lead to Bad Things(tm), cf the
>> > paper above.
>> >=20
>> > This is mitigated by the fact that it can only happen on architectures
>> > that don't set ILLEGAL_POINTER_VALUE (which includes 32-bit arches, an=
d
>> > the ones you listed above). In addition, this has to happen while the
>> > page is owned by page_pool, and while it is DMA-mapped - we already
>> > clear the pp_magic field when releasing the page from page_pool.
>> >=20
>> > I am not sure to what extent the above is a risk we should take pains =
to
>> > avoid, TBH. It seems to me that for this to become a real problem, lot=
s
>> > of other things will already have gone wrong. But happy to defer to th=
e
>> > mm/security folks here.
>>=20
>> For this to be a problem, there already needs to be a use-after-free on
>> a page, which arguably creates many other vectors for attack.
>>=20
>> The lru field of struct page is already used as a generic list pointer
>> in several places in the kernel once ownership of the page is obtained.
>> Any risk of dereferencing lru.next in a use-after-free scenario would
>> technically apply to a bunch of other places in the kernel (grep for
>> page->lru).
>
> We also tried searching for existing exploitation techniques for "struct
> page" use-after-free.  We couldn't find any.  The closest (non-)match I
> found is this fine research (the same project presented differently):
>
> https://i.blackhat.com/BH-US-24/Presentations/US24-Qian-PageJack-A-Powerf=
ul-Exploit-Technique-With-Page-Level-UAF-Thursday.pdf page 33+
> https://arxiv.org/html/2401.17618v2#S4
> https://phrack.org/issues/71/13
>
> The arxiv paper includes this sentence: "To create a page-level UAF, the
> key is to cause a UAF of the struct page objects."  However, we do not
> see them actually do that, and this statement is not found in the slides
> nor in the Phrack article.  Confused.

Thank you for weighing in! I will post an updated version of this patch
with a reference to this discussion and try to summarise the above.

> Thank you for CC'ing me and the kernel-hardening list.  However, please
> do not CC the oss-security list like that, where it's against content
> guidelines.  Only properly focused new postings/threads are acceptable
> there (not CC'ing from/to other lists where only part of the content is
> on-topic, and follow-ups might not be on-topic at all).  See:
>
> https://oss-security.openwall.org/wiki/mailing-lists/oss-security#list-co=
ntent-guidelines
>
> As a moderator for oss-security, I'm going to remove these messages from
> the queue now.  Please drop Cc: oss-security from any further replies.
>
> If desired, we may bring these topics to oss-security separately, with a
> proper Subject line and clear description of what we're talking about.

Noted, thanks!

-Toke

