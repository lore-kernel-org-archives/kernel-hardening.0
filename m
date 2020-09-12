Return-Path: <SRS0=gDDm=CV=lists.openwall.com=kernel-hardening-return-19889-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D05EC433E2
	for <kernel-hardening@archiver.kernel.org>; Sat, 12 Sep 2020 15:05:25 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2B3B220855
	for <kernel-hardening@archiver.kernel.org>; Sat, 12 Sep 2020 15:05:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2B3B220855
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19889-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3540 invoked by uid 550); 12 Sep 2020 15:05:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 31873 invoked from network); 12 Sep 2020 14:47:37 -0000
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Date: Sat, 12 Sep 2020 15:47:22 +0100
From: Mel Gorman <mgorman@suse.de>
To: John Wood <john.wood@gmx.com>
Cc: James Morris <jmorris@namei.org>, Kees Cook <keescook@chromium.org>,
	kernel-hardening@lists.openwall.com,
	Matthew Wilcox <willy@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Iurii Zaikin <yzaikin@google.com>,
	"Serge E. Hallyn" <serge@hallyn.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: Re: [RESEND][RFC PATCH 0/6] Fork brute force attack mitigation
 (fbfam)
Message-ID: <20200912144722.GE3117@suse.de>
References: <20200910202107.3799376-1-keescook@chromium.org>
 <alpine.LRH.2.21.2009121002100.17638@namei.org>
 <202009120055.F6BF704620@keescook>
 <20200912093652.GA3041@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20200912093652.GA3041@ubuntu>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Sat, Sep 12, 2020 at 11:36:52AM +0200, John Wood wrote:
> On Sat, Sep 12, 2020 at 12:56:18AM -0700, Kees Cook wrote:
> > On Sat, Sep 12, 2020 at 10:03:23AM +1000, James Morris wrote:
> > > On Thu, 10 Sep 2020, Kees Cook wrote:
> > >
> > > > [kees: re-sending this series on behalf of John Wood <john.wood@gmx.com>
> > > >  also visible at https://github.com/johwood/linux fbfam]
> > > >
> > > > From: John Wood <john.wood@gmx.com>
> > >
> > > Why are you resending this? The author of the code needs to be able to
> > > send and receive emails directly as part of development and maintenance.
> 
> I tried to send the full patch serie by myself but my email got blocked. After
> get support from my email provider it told to me that my account is young,
> and due to its spam policie I am not allow, for now, to send a big amount
> of mails in a short period. They also informed me that soon I will be able
> to send more mails. The quantity increase with the age of the account.
> 

If you're using "git send-email" then specify --confirm=always and
either manually send a mail every few seconds or use an expect script
like

#!/bin/bash
EXPECT_SCRIPT=
function cleanup() {
	if [ "$EXPECT_SCRIPT" != "" ]; then
		rm $EXPECT_SCRIPT
	fi
}
trap cleanup EXIT

EXPECT_SCRIPT=`mktemp`
cat > $EXPECT_SCRIPT <<EOF
spawn sh ./SEND
expect {
	"Send this email"   { sleep 10; exp_send y\\r; exp_continue }
}
EOF

expect -f $EXPECT_SCRIPT
exit $?

This will work if your provider limits the rate mails are sent rather
than the total amount.

-- 
Mel Gorman
SUSE Labs
