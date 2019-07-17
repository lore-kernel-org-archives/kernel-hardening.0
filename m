Return-Path: <SRS0=fJst=VO=lists.openwall.com=kernel-hardening-return-16491-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58E91C7618F
	for <kernel-hardening@archiver.kernel.org>; Wed, 17 Jul 2019 00:09:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A35D821872
	for <kernel-hardening@archiver.kernel.org>; Wed, 17 Jul 2019 00:09:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A35D821872
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16491-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32764 invoked by uid 550); 17 Jul 2019 00:09:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32742 invoked from network); 17 Jul 2019 00:09:23 -0000
Date: Tue, 16 Jul 2019 17:07:57 -0700
From: "Paul E. McKenney" <paulmck@linux.ibm.com>
To: Joel Fernandes <joel@joelfernandes.org>
Cc: linux-kernel@vger.kernel.org, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Bjorn Helgaas <bhelgaas@google.com>, Borislav Petkov <bp@alien8.de>,
        c0d1n61at3@gmail.com, "David S. Miller" <davem@davemloft.net>,
        edumazet@google.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org,
        kernel-hardening@lists.openwall.com, kernel-team@android.com,
        Lai Jiangshan <jiangshanlai@gmail.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, neilb@suse.com,
        netdev@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Pavel Machek <pavel@ucw.cz>, peterz@infradead.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>, rcu@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, will@kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH 2/9] rcu: Add support for consolidated-RCU reader
 checking (v3)
Message-ID: <20190717000757.GQ14271@linux.ibm.com>
References: <20190715143705.117908-1-joel@joelfernandes.org>
 <20190715143705.117908-3-joel@joelfernandes.org>
 <20190716183833.GD14271@linux.ibm.com>
 <20190716184649.GA130463@google.com>
 <20190716185303.GM14271@linux.ibm.com>
 <20190716220205.GB172157@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716220205.GB172157@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-16_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907160263

On Tue, Jul 16, 2019 at 06:02:05PM -0400, Joel Fernandes wrote:
> On Tue, Jul 16, 2019 at 11:53:03AM -0700, Paul E. McKenney wrote:
> [snip]
> > > > A few more things below.
> > > > > ---
> > > > >  include/linux/rculist.h  | 28 ++++++++++++++++++++-----
> > > > >  include/linux/rcupdate.h |  7 +++++++
> > > > >  kernel/rcu/Kconfig.debug | 11 ++++++++++
> > > > >  kernel/rcu/update.c      | 44 ++++++++++++++++++++++++----------------
> > > > >  4 files changed, 67 insertions(+), 23 deletions(-)
> > > > > 
> > > > > diff --git a/include/linux/rculist.h b/include/linux/rculist.h
> > > > > index e91ec9ddcd30..1048160625bb 100644
> > > > > --- a/include/linux/rculist.h
> > > > > +++ b/include/linux/rculist.h
> > > > > @@ -40,6 +40,20 @@ static inline void INIT_LIST_HEAD_RCU(struct list_head *list)
> > > > >   */
> > > > >  #define list_next_rcu(list)	(*((struct list_head __rcu **)(&(list)->next)))
> > > > >  
> > > > > +/*
> > > > > + * Check during list traversal that we are within an RCU reader
> > > > > + */
> > > > > +
> > > > > +#ifdef CONFIG_PROVE_RCU_LIST
> > > > 
> > > > This new Kconfig option is OK temporarily, but unless there is reason to
> > > > fear malfunction that a few weeks of rcutorture, 0day, and -next won't
> > > > find, it would be better to just use CONFIG_PROVE_RCU.  The overall goal
> > > > is to reduce the number of RCU knobs rather than grow them, must though
> > > > history might lead one to believe otherwise.  :-/
> > > 
> > > If you want, we can try to drop this option and just use PROVE_RCU however I
> > > must say there may be several warnings that need to be fixed in a short
> > > period of time (even a few weeks may be too short) considering the 1000+
> > > uses of RCU lists.
> > Do many people other than me build with CONFIG_PROVE_RCU?  If so, then
> > that would be a good reason for a temporary CONFIG_PROVE_RCU_LIST,
> > as in going away in a release or two once the warnings get fixed.
> 
> PROVE_RCU is enabled by default with PROVE_LOCKING, so it is used quite
> heavilty.
> 
> > > But I don't mind dropping it and it may just accelerate the fixing up of all
> > > callers.
> > 
> > I will let you decide based on the above question.  But if you have
> > CONFIG_PROVE_RCU_LIST, as noted below, it needs to depend on RCU_EXPERT.
> 
> Ok, will make it depend. But yes for temporary purpose, I will leave it as a
> config and remove it later.

Very good, thank you!  Plus you got another ack.  ;-)

							Thanx, Paul
