From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1495365245-3185-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
	<20170522140306.GA3907@infradead.org>
	<d98f4cd5-3f21-3f7b-2842-12b9a009e453@schaufler-ca.com>
	<d25e2fd3-da11-4ec0-8edc-f1327c04fa6e@huawei.com>
	<af26581e-6f5a-3fc2-dc58-8376328a0ad9@schaufler-ca.com>
In-Reply-To: <af26581e-6f5a-3fc2-dc58-8376328a0ad9@schaufler-ca.com>
Message-Id: <201705230543.FDH39582.LFQHJOtFOOFSMV@I-love.SAKURA.ne.jp>
Date: Tue, 23 May 2017 05:43:16 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: [kernel-hardening] Re: [PATCH] LSM: Make security_hook_heads a local variable.
To: casey@schaufler-ca.com, igor.stoppa@huawei.com, hch@infradead.org
Cc: linux-security-module@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, james.l.morris@oracle.com, keescook@chromium.org, paul@paul-moore.com, sds@tycho.nsa.gov
List-ID: <kernel-hardening.lists.openwall.com>

Casey Schaufler wrote:
> On 5/22/2017 12:50 PM, Igor Stoppa wrote:
> > On 22/05/17 18:09, Casey Schaufler wrote:
> >> On 5/22/2017 7:03 AM, Christoph Hellwig wrote:
> > [...]
> >
> >>> But even with those we can still chain
> >>> them together with a list with external linkage.
> >> I gave up that approach in 2012. Too many unnecessary calls to
> >> null functions, and massive function vectors with a tiny number
> >> of non-null entries. From a data structure standpoint, it was
> >> just wrong. The list scheme is exactly right for the task at
> >> hand.
> > I understand this as a green light, for me to continue with the plan of
> > using LSM Hooks as example for making dynamically allocated data become
> > read-only, using also Tetsuo's patch (thanks, btw).
> 
> I still don't like the assumption that a structure of
> N elements can be assumed to be the same as an array
> of N elements.

I think we can use "enum" and call via index numbers while preserving
current "union" for type checking purpose.
