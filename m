Return-Path: <kernel-hardening-return-21610-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 422D2C54E94
	for <kernel-hardening@archiver.kernel.org>; Thu, 26 Jan 2023 16:31:35 +0000 (UTC)
Received: (qmail 7389 invoked by uid 550); 26 Jan 2023 16:31:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5848 invoked from network); 26 Jan 2023 16:29:29 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674750557;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uQ5AeqRdHoqDiMiO534YbFssRp+d+rc3l3U4CDokNu0=;
	b=fhQGYpOATd3j+wWS7cdtxzXN9lzb4sNEVHp0geJXFd9BiFFqjsILa6WXtoszo/hmOFgzJ/
	7ybPyOJxQHjdAUo8C0brOdTOkqvNTvhtV6ZAFpjfNs+JkRlhxnlPHZib/SLyoVrRMjr7mH
	J1lJYTVBxDSXW5QHuK0kCMJoVFuDFcI=
X-MC-Unique: 7jKrE0-_OiqEd25yOE3dzg-1
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uQ5AeqRdHoqDiMiO534YbFssRp+d+rc3l3U4CDokNu0=;
        b=LlhIsAZVZsvdreFPcP5vNZLEcTeqJYfsO/ReMpVXyDw6pZb6b9XEeDvvE7QdyfAMxI
         GNMuysTtJ3aJx7oyaBr76yNSQxlrbjTUaNYUEQ6x4Kk1sPN6w6hTRV3pYDFc+fX0AKww
         EOhY70OFnF5vMmjPN46lj5CzenDjzRggUqK8gsOppk4jLFfX9MTfHeeck0l935jUW7NP
         H1ZsJT/ic+U+V/qwTFRTWyNVlZ8zS1lI81jQ4geKJW2iY5bqPDTtToH7bmEhGIH0MU/W
         HTEWcKlRD2fQVVWUvM3EDNaLWMyT5klJ57odoosRjPbaElH2qxyqLuNMbOJVBrTOgPsi
         YrLw==
X-Gm-Message-State: AFqh2kqP9wetAf5ixlYouFnLFGWysyD4hIXEOi0rPcoyal/UkFtElrZM
	kDZRG7F6hK12araRPMgM+yyPAiqkroM3aFV0I9GboQ+y03wZGEp7AH9lVuKfCAdTcHj84Ix9Xd9
	BX307vO75yrNiP+xdermdd8dvHmrINXnSfw==
X-Received: by 2002:a05:600c:1c9d:b0:3da:db4:6105 with SMTP id k29-20020a05600c1c9d00b003da0db46105mr36614918wms.37.1674750554555;
        Thu, 26 Jan 2023 08:29:14 -0800 (PST)
X-Google-Smtp-Source: AMrXdXu/XUMPJtU5iYBp8WyqQ43Iwj8Vmxw+tnCVJfRHeV2qUt/JRWJYMx6HGI88x+KBLozOr/fmeg==
X-Received: by 2002:a05:600c:1c9d:b0:3da:db4:6105 with SMTP id k29-20020a05600c1c9d00b003da0db46105mr36614890wms.37.1674750554324;
        Thu, 26 Jan 2023 08:29:14 -0800 (PST)
Date: Thu, 26 Jan 2023 11:29:08 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Shishkin, Alexander" <alexander.shishkin@intel.com>,
	"Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"Kuppuswamy, Sathyanarayanan" <sathyanarayanan.kuppuswamy@intel.com>,
	"Kleen, Andi" <andi.kleen@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	"Wunner, Lukas" <lukas.wunner@intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Jason Wang <jasowang@redhat.com>,
	"Poimboe, Josh" <jpoimboe@redhat.com>,
	"aarcange@redhat.com" <aarcange@redhat.com>,
	Cfir Cohen <cfir@google.com>, Marc Orr <marcorr@google.com>,
	"jbachmann@google.com" <jbachmann@google.com>,
	"pgonda@google.com" <pgonda@google.com>,
	"keescook@chromium.org" <keescook@chromium.org>,
	James Morris <jmorris@namei.org>,
	Michael Kelley <mikelley@microsoft.com>,
	"Lange, Jon" <jlange@microsoft.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: Linux guest kernel threat model for Confidential Computing
Message-ID: <20230126105618-mutt-send-email-mst@kernel.org>
References: <DM8PR11MB57505481B2FE79C3D56C9201E7CE9@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Y9EkCvAfNXnJ+ATo@kroah.com>
 <DM8PR11MB5750FA4849C3224F597C101AE7CE9@DM8PR11MB5750.namprd11.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <DM8PR11MB5750FA4849C3224F597C101AE7CE9@DM8PR11MB5750.namprd11.prod.outlook.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 25, 2023 at 03:29:07PM +0000, Reshetova, Elena wrote:
> And this is a very special aspect of 'hardening' since it is about hardening a kernel
> under different threat model/assumptions. 

I am not sure it's that special in that hardening IMHO is not a specific
threat model or a set of assumptions. IIUC it's just something that
helps reduce severity of vulnerabilities.  Similarly, one can use the CC
hardware in a variety of ways I guess. And one way is just that -
hardening linux such that ability to corrupt guest memory does not
automatically escalate into guest code execution.

If you put it this way, you get to participate in a well understood
problem space instead of constantly saying "yes but CC is special".  And
further, you will now talk about features as opposed to fixing bugs.
Which will stop annoying people who currently seem annoyed by the
implication that their code is buggy simply because it does not cache in
memory all data read from hardware. Finally, you then don't really need
to explain why e.g. DoS is not a problem but info leak is a problem - when
for many users it's actually the reverse - the reason is not that it's
not part of a threat model - which then makes you work hard to define
the threat model - but simply that CC hardware does not support this
kind of hardening.

-- 
MST

