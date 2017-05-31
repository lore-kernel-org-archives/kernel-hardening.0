From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201705281026.EHD04622.HJFOLQFMSOtFOV@I-love.SAKURA.ne.jp>
	<alpine.LRH.2.20.1705302021090.31018@namei.org>
	<201705302329.IEB05735.FLJOFHSQVtOOFM@I-love.SAKURA.ne.jp>
	<20170530162550.19ba1811@alans-desktop>
	<alpine.LRH.2.20.1705310858430.6920@namei.org>
In-Reply-To: <alpine.LRH.2.20.1705310858430.6920@namei.org>
Message-Id: <201705311941.CGD64590.MOFSOLFJtQFOVH@I-love.SAKURA.ne.jp>
Date: Wed, 31 May 2017 19:41:46 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Subject: [kernel-hardening] Re: [PATCH] LSM: Convert security_hook_heads into explicit array of struct list_head
To: jmorris@namei.org, gnomes@lxorguk.ukuu.org.uk
Cc: keescook@chromium.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, casey@schaufler-ca.com, hch@infradead.org, igor.stoppa@huawei.com, james.l.morris@oracle.com, paul@paul-moore.com, sds@tycho.nsa.gov
List-ID: <kernel-hardening.lists.openwall.com>

James Morris wrote:
> On Tue, 30 May 2017, Alan Cox wrote:
> 
> > On Tue, 30 May 2017 23:29:10 +0900
> > Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:
> > 
> > > James Morris wrote:
> > > > On Sun, 28 May 2017, Tetsuo Handa wrote:
> > > >   
> > > > > can afford enabling". And we know that we cannot merge all security modules
> > > > > into mainline. Thus, allowing LKM-based LSM modules is inevitable.  
> > > > 
> > > > Nope, it's not inevitable.  The LSM API only caters to in-tree users.
> > > > 
> > > > I'm not sure why you persist against this.  
> > > 
> > > Then, we are willing to accept LSM modules with users less than 10, aren't we?
> > 
> > Why not if they are properly written and maintained. Historically we've
> > supported an entire architecture that had one machine ever built. We
> > supported a strange subclass of x86 machines for many years because James
> > Bottomley cared enough to do the work. We still support M68K, PA-RISC and
> > other stuff as well as plenty of hardware which probably has few users -
> > providing it doesn't cause maintenance problems.
> 
> This is what we as a community came up with in 2008:
> 
>   "Essentially, any new security project - not limited to LSMs - should be 
>    accompanied by a clear and concise document outlining its requirements 
>    and expected uses. This is to allow both security and regular folk to 
>    perform review of the code in terms of how it meets the specified 
>    requirements, and to avoid getting bogged down in unresolvable 
>    discussions about the project’s security model."
> 
> From https://blog.namei.org/2008/12/11/the-arjan-protocol/
> 
> (Not sure if the original document at Kernel Trap still exists, alas).
> 
> So what we need is clear design documentation that the code can be 
> reviewed against.  There is nothing about the number of users.  If the 
> code is simply using the existing API and meets its design goals, it's 
> pretty straightforward.  If changes to the API or core kernel are also 
> required, then more discussion and review will be needed.

I saw several companies who ship their embedded devices with
single-function LSM modules (e.g. restrict only mount operation and
ptrace operation). What is unfortunate is that their LSM modules had
never been proposed for upstream, and thus bugs remained unnoticed.

They cannot afford enabling SELinux or SMACK or TOMOYO or AppArmor
in their products, whereas LSM community tends to think as whether
SELinux or SMACK or TOMOYO or AppArmor can do what they want.

It will become possible to get single-function LSM modules merged if we
stop saying "you can do it with SELinux or SMACK or TOMOYO or AppArmor".
But there is the other barrier if we think about distributions.

If distributors enable all LSM modules which are wanted by their users
(e.g. Ubuntu, or LSM modules dedicated for their embedded devices), there
is no need to support LKM-based LSM modules.

But otherwise (e.g. https://bugzilla.redhat.com/show_bug.cgi?id=542986 ),
we are forcing users to rebuild distribution kernels even if the LSM code is
available in vanilla kernels. It is a sort of enforcing CONFIG_MODULES=n.
Offering users the ability to use LSM modules as LKM and allowing users to
use LSM modules which are not enabled by distributors as LKM at user's own
risk is a realistic choice, and therefore I developed AKARI.

The location we are directing to via read-only LSM hooks seems to be: let's
accept source code of LSM modules which they want (so that LKM-based LSM
modules won't be needed), but let's prevent users from running binary code
of LSM modules which they want (by forcing users to rebuild their kernels
via lack of ability to use LKM-based LSM modules). My customers cannot afford
enabling SELinux, but my customers cannot rebuild their kernels because
rebuilding makes it even more difficult to get help from support centers.
Therefore, my customers remain unable to use LSM modules which they want.
This is really unfortunate for me.
