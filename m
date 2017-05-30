Date: Wed, 31 May 2017 09:06:04 +1000 (AEST)
From: James Morris <jmorris@namei.org>
In-Reply-To: <20170530162550.19ba1811@alans-desktop>
Message-ID: <alpine.LRH.2.20.1705310858430.6920@namei.org>
References: <1495883858-3336-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp> <CAGXu5jJ045iaDfoW+2dXU+U-KhfnNH1WX5ngUW9dHyS5Yn3EGg@mail.gmail.com> <201705281026.EHD04622.HJFOLQFMSOtFOV@I-love.SAKURA.ne.jp> <alpine.LRH.2.20.1705302021090.31018@namei.org>
 <201705302329.IEB05735.FLJOFHSQVtOOFM@I-love.SAKURA.ne.jp> <20170530162550.19ba1811@alans-desktop>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="1665246916-223913274-1496185566=:6920"
Subject: [kernel-hardening] Re: [PATCH] LSM: Convert security_hook_heads into explicit array of
 struct list_head
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, keescook@chromium.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, casey@schaufler-ca.com, hch@infradead.org, igor.stoppa@huawei.com, james.l.morris@oracle.com, paul@paul-moore.com, sds@tycho.nsa.gov
List-ID: <kernel-hardening.lists.openwall.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1665246916-223913274-1496185566=:6920
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 30 May 2017, Alan Cox wrote:

> On Tue, 30 May 2017 23:29:10 +0900
> Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:
> 
> > James Morris wrote:
> > > On Sun, 28 May 2017, Tetsuo Handa wrote:
> > >   
> > > > can afford enabling". And we know that we cannot merge all security modules
> > > > into mainline. Thus, allowing LKM-based LSM modules is inevitable.  
> > > 
> > > Nope, it's not inevitable.  The LSM API only caters to in-tree users.
> > > 
> > > I'm not sure why you persist against this.  
> > 
> > Then, we are willing to accept LSM modules with users less than 10, aren't we?
> 
> Why not if they are properly written and maintained. Historically we've
> supported an entire architecture that had one machine ever built. We
> supported a strange subclass of x86 machines for many years because James
> Bottomley cared enough to do the work. We still support M68K, PA-RISC and
> other stuff as well as plenty of hardware which probably has few users -
> providing it doesn't cause maintenance problems.

This is what we as a community came up with in 2008:

  "Essentially, any new security project—not limited to LSMs—should be 
   accompanied by a clear and concise document outlining its requirements 
   and expected uses. This is to allow both security and regular folk to 
   perform review of the code in terms of how it meets the specified 
   requirements, and to avoid getting bogged down in unresolvable 
   discussions about the project’s security model."

>From https://blog.namei.org/2008/12/11/the-arjan-protocol/

(Not sure if the original document at Kernel Trap still exists, alas).

So what we need is clear design documentation that the code can be 
reviewed against.  There is nothing about the number of users.  If the 
code is simply using the existing API and meets its design goals, it's 
pretty straightforward.  If changes to the API or core kernel are also 
required, then more discussion and review will be needed.




- James
-- 
James Morris 
<jmorris@namei.org>

--1665246916-223913274-1496185566=:6920--
