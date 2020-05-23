Return-Path: <SRS0=y4Gn=7F=lists.openwall.com=kernel-hardening-return-18863-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85F12C433E0
	for <kernel-hardening@archiver.kernel.org>; Sat, 23 May 2020 10:31:36 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C9B67206DD
	for <kernel-hardening@archiver.kernel.org>; Sat, 23 May 2020 10:31:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=sakamocchi.jp header.i=@sakamocchi.jp header.b="H3rWb5HU";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="CcVRcc9i"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C9B67206DD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sakamocchi.jp
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18863-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11548 invoked by uid 550); 23 May 2020 10:31:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30383 invoked from network); 23 May 2020 07:59:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
	 h=date:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=fm1; bh=K9bdneoooJ1uSBw5jkomBqz3iW0
	HsoKgOxHBuN88dzA=; b=H3rWb5HUYcQn7iZXb7kBxoSo164u2D2hVvlNCeXfw33
	vPfXrucVHEPaNFgPKynsNfLu9sswkct6TBU+ulxNIaw6VejbT3wIjZSh1SBgRWed
	37G/3vgYwnuytM7AUt8VmRelj55JNfHGl1DFJBnkktNp8gbthsSgRqUD1vb3Dioo
	oApBMjnbaUmoQHmdsXR/FXiAtvFI3xc/C56alJZluumRtFOFuQWhJ6VtYXGn29mx
	/uHQLUxc7EcEWeJSmD0RVHQVwxL4y6E+vJ36WC4ktDt+GWzQYna8G67frcbar58V
	WkkaAGX9eKQ7ZdE0czbjq4KF00ZmXPj+KX9G9WSf7qA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to:x-me-proxy
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=K9bdne
	oooJ1uSBw5jkomBqz3iW0HsoKgOxHBuN88dzA=; b=CcVRcc9iulo5FrFWsvMwNI
	lnO1f6CwgY494tKBtmumqn8rFALyNsIivbS9xjEuFDxNvieYN9l7bH8WRLr+piIR
	Hj1jylf3k9X9SMeOYOzEMKd1s/EJHu1VdQ7/+FqtPUVATE/KUoEHME8/ctLx+itm
	eagXQ48TrSjcTD6En5e10/SVYN8DPtqRQZIwzDFDZ6T4+ggwg+Z5pKCf5SwFjZNy
	H1xpeXO1XhBuis4MzAWZOClWQIJIggq4HU8TTMcNqQr+dMJbbRE/O5YaYggluu+v
	hkouwGdlZiV8+Gw6yhghDLUytmFQ+kUM8upUDnJlv3Gq1dPGRi5Cmr7Q6VFMCqQA
	==
X-ME-Sender: <xms:xNfIXpIYAmfqIChvyJM_rKIA0yUIxHG6Z0AgyhTnotb0mwkBuTquYA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddugedguddvvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepvfgrkhgr
    shhhihcuufgrkhgrmhhothhouceoohdqthgrkhgrshhhihesshgrkhgrmhhotggthhhird
    hjpheqnecuggftrfgrthhtvghrnhephfefleekfeevgffhhfehudetkeeivdeuvdelgeej
    jefhffegkeffffdugfevudetnecuffhomhgrihhnpehgihhthhhusgdrtghomhdprghlsh
    grqdhprhhojhgvtghtrdhorhhgnecukfhppedukedtrddvfeehrdefrdehgeenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehoqdhtrghkrghshh
    hisehsrghkrghmohgttghhihdrjhhp
X-ME-Proxy: <xmx:xNfIXlK-hUj2c_B-TJAeEP4Nv8ItDjNR79jB0y4kcSeRYV0cYVe9Ng>
    <xmx:xNfIXhsN6JBRk4ydpuWG_Wqdcl1Uy2vhIKaqbVVFOHa-B7fcj_lI2w>
    <xmx:xNfIXqZCW_JuSxoblr1zefmM5ZBES2YNtOCd4SmdkHLQMAoGY4rc-Q>
    <xmx:xdfIXqDiHCJPhSs3amiBVLQ9b3oEfEyPZLCS9vGA9sPVJvr-kmK65UXOCtI>
Date: Sat, 23 May 2020 16:58:54 +0900
From: Takashi Sakamoto <o-takashi@sakamocchi.jp>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Oscar Carter <oscar.carter@gmx.com>, stable <stable@vger.kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Clemens Ladisch <clemens@ladisch.de>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
	kernel-hardening@lists.openwall.com,
	linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	"Lev R . Oshvang ." <levonshe@gmail.com>
Subject: Re: [PATCH v2] firewire: Remove function callback casts
Message-ID: <20200523075854.GA170441@workstation>
Mail-Followup-To: Greg KH <gregkh@linuxfoundation.org>,
	Oscar Carter <oscar.carter@gmx.com>,
	stable <stable@vger.kernel.org>, Kees Cook <keescook@chromium.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Clemens Ladisch <clemens@ladisch.de>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
	kernel-hardening@lists.openwall.com,
	linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	"Lev R . Oshvang ." <levonshe@gmail.com>
References: <20200519173425.4724-1-oscar.carter@gmx.com>
 <20200520061624.GA25690@workstation>
 <20200522174308.GB3059@ubuntu>
 <20200523061033.GB3131938@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200523061033.GB3131938@kroah.com>

Hi Greg,

On Sat, May 23, 2020 at 08:10:33AM +0200, Greg KH wrote:
> On Fri, May 22, 2020 at 07:43:08PM +0200, Oscar Carter wrote:
> > Hi,
> > 
> > On Wed, May 20, 2020 at 03:16:24PM +0900, Takashi Sakamoto wrote:
> > > Hi,
> > >
> > > I'm an author of ALSA firewire stack and thanks for the patch. I agree with
> > > your intention to remove the cast of function callback toward CFI build.
> > >
> > > Practically, the isochronous context with FW_ISO_CONTEXT_RECEIVE_MULTICHANNEL
> > > is never used by in-kernel drivers. Here, I propose to leave current
> > > kernel API (fw_iso_context_create() with fw_iso_callback_t) as is.
> 
> If it's not used by anyone, why is it still there?  Can't we just delete
> it?

For this patchset, I followed to the theory to keep backward compatibility
when adding any change, and it's what I'd like to discuss.

The isoc context of multichannel mode is also available for userspace
applications, and libhinoko[1] uses it. In a point of backward
compatibility for userspace, we can't delete the mode.

(Practically, the mode is useful for the purpose of packet sniffing in
bus and helpful to my work for development of ALSA firewire stack[2].)

On the other hand, there's no unit driver to use the mode in upstream
kernel. It's unlikely to use the mode for unit driver since the mode is
not specific to unit functionality. In my opinion, it's reasonable to
lose backward compatibility slightly by hiding the multichannel mode
from in-kernel unit driver.

I'll post v2 patchset later and I'd like you to merge them if no
objections from the others for the loss of backward compatibility.

[1] https://github.com/takaswie/libhinoko
[2] https://mailman.alsa-project.org/pipermail/alsa-devel/2019-April/147862.html


Regards

Takashi Sakamoto
