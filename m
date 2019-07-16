Return-Path: <SRS0=S9bG=VN=lists.openwall.com=kernel-hardening-return-16487-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 475C1C7618F
	for <kernel-hardening@archiver.kernel.org>; Tue, 16 Jul 2019 18:51:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A594F2173C
	for <kernel-hardening@archiver.kernel.org>; Tue, 16 Jul 2019 18:51:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A594F2173C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16487-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1261 invoked by uid 550); 16 Jul 2019 18:51:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1180 invoked from network); 16 Jul 2019 18:51:17 -0000
Date: Tue, 16 Jul 2019 11:50:01 -0700
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
Subject: Re: [PATCH v2 2/9] rcu: Add support for consolidated-RCU reader
 checking
Message-ID: <20190716185001.GL14271@linux.ibm.com>
References: <20190712170024.111093-1-joel@joelfernandes.org>
 <20190712170024.111093-3-joel@joelfernandes.org>
 <20190716182237.GA22819@linux.ibm.com>
 <20190716183517.GA129705@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716183517.GA129705@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-16_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907160230

On Tue, Jul 16, 2019 at 02:35:17PM -0400, Joel Fernandes wrote:
> On Tue, Jul 16, 2019 at 11:22:37AM -0700, Paul E. McKenney wrote:
> > On Fri, Jul 12, 2019 at 01:00:17PM -0400, Joel Fernandes (Google) wrote:
> > > This patch adds support for checking RCU reader sections in list
> > > traversal macros. Optionally, if the list macro is called under SRCU or
> > > other lock/mutex protection, then appropriate lockdep expressions can be
> > > passed to make the checks pass.
> > > 
> > > Existing list_for_each_entry_rcu() invocations don't need to pass the
> > > optional fourth argument (cond) unless they are under some non-RCU
> > > protection and needs to make lockdep check pass.
> > > 
> > > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > 
> > If you fold in the checks for extra parameters, I will take this
> > one and also 1/9.
> 
> I folded the checks in and also threw in the rcu-sync with Oleg's ack:
> 
> Could you pull into /dev branch?
> 
> git pull https://github.com/joelagnel/linux-kernel.git list-first-three
> (Based on your dev branch)

Given that I am going to have to rebase these a few times, please
email a v4.

							Thanx, Paul
