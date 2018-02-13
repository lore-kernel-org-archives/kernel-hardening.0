Return-Path: 
 <kernel-hardening-return-11745-ydroneaud=opteya.com@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
From: Igor Stoppa <igor.stoppa@huawei.com>
Date: Tue, 13 Feb 2018 15:20:03 +0000
References: <20180124175631.22925-1-igor.stoppa@huawei.com>
 <20180124175631.22925-5-igor.stoppa@huawei.com>
 <CAG48ez0JRU8Nmn7jLBVoy6SMMrcj46R0_R30Lcyouc4R9igi-g@mail.gmail.com>
 <20180126053542.GA30189@bombadil.infradead.org>
 <alpine.DEB.2.20.1802021236510.31548@nuc-kabylake>
 <f2ddaed0-313e-8664-8a26-9d10b66ed0c5@huawei.com>
 <b75b5903-0177-8ad9-5c2b-fc63438fb5f2@huawei.com>
 <CAFUG7CfrCpcbwgf5ixMC5EZZgiVVVp1NXhDHK1UoJJcC08R2qQ@mail.gmail.com>
 <8818bfd4-dd9f-f279-0432-69b59531bd41@huawei.com>
 <CAFUG7CeUhFcvA82uZ2ZH1j_6PM=aBo4XmYDN85pf8G0gPU44dg@mail.gmail.com>
 <17e5b515-84c8-dca2-1695-cdf819834ea2@huawei.com>
 <CAGXu5j+LS1pgOOroi7Yxp2nh=DwtTnU3p-NZa6bQu_wkvvVkwg@mail.gmail.com>,<414027d3-dd73-cf11-dc2a-e8c124591646@redhat.com>
In-Reply-To: <414027d3-dd73-cf11-dc2a-e8c124591646@redhat.com>
Content-Language: en-GB
Content-Type: multipart/alternative;
	boundary="_000_688F43F436AB4D988B8234437CFD85BC_"
MIME-Version: 1.0
Subject: RE: [kernel-hardening] [PATCH 4/6] Protectable Memory
Message-ID: <cdec5d2aaa5256c2fab4f084931ae39e3a9f9df6.camel@huawei.com>
To: Laura Abbott <labbott@redhat.com>, Kees Cook <keescook@chromium.org>
Cc: Boris Lukashev <blukashev@sempervictus.com>, Christopher Lameter <cl@linux.com>, Matthew Wilcox <willy@infradead.org>, Jann Horn <jannh@google.com>, Jerome Glisse <jglisse@redhat.com>, Michal Hocko <mhocko@kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-security-module <linux-security-module@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, kernel list <linux-kernel@vger.kernel.org>, Kernel
 Hardening <kernel-hardening@lists.openwall.com>


--_000_688F43F436AB4D988B8234437CFD85BC_
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: 8bit

hi,
apologies for (probably) breaking any email etiquette, but i'm travelling and i have available only the corporate mail client.
I'll reply more extensively to all the comments i go next week, when i'm back to the office.

In the meanwhile i would like to point out that I had already addressed this, in past thread, but got no reply.

To recap:
-1) vmalloced memory is harder to attack than kmalloced, because it requires the attacker to figuere out also the physical address. Currently it's sufficient to identify the randomized base address and the offset in memory of the victim.
I have not seen comments about this statement I made. Is it incorrect?
-2) this patchset is about protecting something that right now is not protected at all. That should be the starting point for comparison. If it was possible to have separate section like const or _ro_after init, the situation would be different, but i was told that it's not possible. furthermore, it would require reserving a fixed size "zone", i think.
-3)What is the attack we want to make harder to perform? Because even const data can be attacked, if we assume that the attacker can alter page mappings. In reality, the only safe way would be to have one-way only protection. But we do not have it. Why alterations of page properties are not considered a risk and the physmap is?
And how would it be easier (i suppose) to attack the latter?
I'm all for hardening what is possible, but I feel I do not have full understanding of some of the assumptions being made here.
Getting some answers to my questions above might help me seeing the point being made.

--
thanks, igor



--------------------------------------------------
Igor Stoppa Igor Stoppa
M:
E: igor.stoppa@huawei.com<mailto:igor.stoppa@huawei.com>
2012<tel:2012>实验室-赫尔辛基研究所
2012<tel:2012> Laboratories-Helsinki Research Center
From:Laura Abbott
To:Kees Cook,Igor Stoppa,
Cc:Boris Lukashev,Christopher Lameter,Matthew Wilcox,Jann Horn,Jerome Glisse,Michal Hocko,Christoph Hellwig,linux-security-module,Linux-MM,kernel list,Kernel Hardening,
Date:2018-02-13 00:40:54
Subject:Re: [kernel-hardening] [PATCH 4/6] Protectable Memory

On 02/12/2018 03:27 PM, Kees Cook wrote:
> On Sun, Feb 4, 2018 at 7:05 AM, Igor Stoppa <igor.stoppa@huawei.com> wrote:
>> On 04/02/18 00:29, Boris Lukashev wrote:
>>> On Sat, Feb 3, 2018 at 3:32 PM, Igor Stoppa <igor.stoppa@huawei.com> wrote:
>>
>> [...]
>>
>>>> What you are suggesting, if I have understood it correctly, is that,
>>>> when the pool is protected, the addresses already given out, will become
>>>> traps that get resolved through a lookup table that is built based on
>>>> the content of each allocation.
>>>>
>>>> That seems to generate a lot of overhead, not to mention the fact that
>>>> it might not play very well with the MMU.
>>>
>>> That is effectively what i'm suggesting - as a form of protection for
>>> consumers against direct reads of data which may have been corrupted
>>> by some irrelevant means. In the context of pmalloc, it would probably
>>> be a separate type of ro+verified pool
>> ok, that seems more like an extension though.
>>
>> ATM I am having problems gaining traction to get even the basic merged :-)
>>
>> I would consider this as a possibility for future work, unless it is
>> said that it's necessary for pmalloc to be accepted ...
>
> I would agree: let's get basic functionality in first. Both
> verification and the physmap part can be done separately, IMO.

Skipping over physmap leaves a pretty big area of exposure that could
be difficult to solve later. I appreciate this might block basic
functionality but I don't think we should just gloss over it without
at least some idea of what we would do.

Thanks,
Laura

--_000_688F43F436AB4D988B8234437CFD85BC_
Content-Type: text/html; charset="gb2312"
Content-Transfer-Encoding: 8bit

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<meta name="Generator" content="Microsoft Exchange Server">
<!-- converted from text --><style><!-- .EmailQuote { margin-left: 1pt; padding-left: 4pt; border-left: #800000 2px solid; } --></style>
</head>
<body>
<style type="text/css">
<!--
-->
</style>
<div>
<div>hi,<br>
apologies for (probably) breaking any email etiquette, but i'm travelling and i have available only the corporate mail client.<br>
I'll reply more extensively to all the comments i go next week, when i'm back to the office.<br>
<br>
In the meanwhile i would like to point out that I had already addressed this, in past thread, but got no reply.<br>
<br>
To recap:<br>
-1) vmalloced memory is harder to attack than kmalloced, because it requires the attacker to figuere out also the physical address. Currently it's sufficient to identify the randomized base address and the offset in memory of the victim.<br>
I have not seen comments about this statement I made. Is it incorrect?<br>
-2) this patchset is about protecting something that right now is not protected at all. That should be the starting point for comparison. If it was possible to have separate section like const or _ro_after init, the situation would be different, but i was told
 that it's not possible. furthermore, it would require reserving a fixed size &quot;zone&quot;, i think.<br>
-3)What is the attack we want to make harder to perform? Because even const data can be attacked, if we assume that the attacker can alter page mappings. In reality, the only safe way would be to have one-way only protection. But we do not have it. Why alterations
 of page properties are not considered a risk and the physmap is?<br>
And how would it be easier (i suppose) to attack the latter?<br>
I'm all for hardening what is possible, but I feel I do not have full understanding of some of the assumptions being made here.<br>
Getting some answers to my questions above might help me seeing the point being made.<br>
<br>
--<br>
thanks, igor<br>
<br>
<br>
<br>
</div>
<div></div>
<div>--------------------------------------------------<br>
Igor Stoppa Igor Stoppa<br>
M:<br>
E: <a href="mailto:igor.stoppa@huawei.com">igor.stoppa@huawei.com</a><br>
<a href="tel:2012">2012</a>实验室-赫尔辛基研究所<br>
<a href="tel:2012">2012</a> Laboratories-Helsinki Research Center</div>
<div name="x_AnyOffice-Background-Image" style="border-top:1px solid #B5C4DF; padding:8px">
<div style="word-break:break-all"><b>From:</b>Laura Abbott</div>
<div style="word-break:break-all"><b>To:</b>Kees Cook,Igor Stoppa,</div>
<div style="word-break:break-all"><b>Cc:</b>Boris Lukashev,Christopher Lameter,Matthew Wilcox,Jann Horn,Jerome Glisse,Michal Hocko,Christoph Hellwig,linux-security-module,Linux-MM,kernel list,Kernel Hardening,</div>
<div style="word-break:break-all"><b>Date:</b>2018-02-13 00:40:54</div>
<div style="word-break:break-all"><b>Subject:</b>Re: [kernel-hardening] [PATCH 4/6] Protectable Memory</div>
<div><br>
</div>
</div>
</div>
<font size="2"><span style="font-size:10pt;">
<div class="PlainText">On 02/12/2018 03:27 PM, Kees Cook wrote:<br>
&gt; On Sun, Feb 4, 2018 at 7:05 AM, Igor Stoppa &lt;igor.stoppa@huawei.com&gt; wrote:<br>
&gt;&gt; On 04/02/18 00:29, Boris Lukashev wrote:<br>
&gt;&gt;&gt; On Sat, Feb 3, 2018 at 3:32 PM, Igor Stoppa &lt;igor.stoppa@huawei.com&gt; wrote:<br>
&gt;&gt;<br>
&gt;&gt; [...]<br>
&gt;&gt;<br>
&gt;&gt;&gt;&gt; What you are suggesting, if I have understood it correctly, is that,<br>
&gt;&gt;&gt;&gt; when the pool is protected, the addresses already given out, will become<br>
&gt;&gt;&gt;&gt; traps that get resolved through a lookup table that is built based on<br>
&gt;&gt;&gt;&gt; the content of each allocation.<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; That seems to generate a lot of overhead, not to mention the fact that<br>
&gt;&gt;&gt;&gt; it might not play very well with the MMU.<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; That is effectively what i'm suggesting - as a form of protection for<br>
&gt;&gt;&gt; consumers against direct reads of data which may have been corrupted<br>
&gt;&gt;&gt; by some irrelevant means. In the context of pmalloc, it would probably<br>
&gt;&gt;&gt; be a separate type of ro&#43;verified pool<br>
&gt;&gt; ok, that seems more like an extension though.<br>
&gt;&gt;<br>
&gt;&gt; ATM I am having problems gaining traction to get even the basic merged :-)<br>
&gt;&gt;<br>
&gt;&gt; I would consider this as a possibility for future work, unless it is<br>
&gt;&gt; said that it's necessary for pmalloc to be accepted ...<br>
&gt; <br>
&gt; I would agree: let's get basic functionality in first. Both<br>
&gt; verification and the physmap part can be done separately, IMO.<br>
<br>
Skipping over physmap leaves a pretty big area of exposure that could<br>
be difficult to solve later. I appreciate this might block basic<br>
functionality but I don't think we should just gloss over it without<br>
at least some idea of what we would do.<br>
<br>
Thanks,<br>
Laura<br>
</div>
</span></font>
</body>
</html>

--_000_688F43F436AB4D988B8234437CFD85BC_--
