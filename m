Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Wed, 7 Sep 2011 15:23:01 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110907112301.GA12157@albatros>
References: <20110901080508.GF30615@sun>
 <20110902163711.GA3124@albatros>
 <20110905185358.GA2103@albatros>
 <20110905192009.GJ761@sun>
 <20110905194908.GA2690@albatros>
 <20110905203627.GL761@sun>
 <20110906101518.GA4799@albatros>
 <20110906165144.GJ18425@mtj.dyndns.org>
 <20110906172952.GA28055@albatros>
 <20110906173341.GM18425@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110906173341.GM18425@mtj.dyndns.org>
Subject: [kernel-hardening] Re: [patch 2/2] fs, proc: Introduce the /proc/<pid>/map_files/
 directory v6
To: Tejun Heo <tj@kernel.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, containers@lists.osdl.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Nathan Lynch <ntl@pobox.com>, kernel-hardening@lists.openwall.com, Oren Laadan <orenl@cs.columbia.edu>, Daniel Lezcano <dlezcano@fr.ibm.com>, Glauber Costa <glommer@parallels.com>, James Bottomley <jbottomley@parallels.com>, Alexey Dobriyan <adobriyan@gmail.com>, Al Viro <viro@ZenIV.linux.org.uk>, Pavel Emelyanov <xemul@parallels.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On Wed, Sep 07, 2011 at 02:33 +0900, Tejun Heo wrote:
> On Tue, Sep 06, 2011 at 09:29:52PM +0400, Vasiliy Kulikov wrote:
> > I agree with you.  I don't think that showing system-global debug
> > information to all users by default is the right thing.  But some people
> > doesn't agree with this point of view:
> > 
> > http://thread.gmane.org/gmane.linux.kernel/1108378
> 
> Yeap, I know there are two sides of the discussion but if one takes
> the position that hiding such global debug info is more harmful, it's
> only crazier to hide such information from each individual users of
> the said global facility.  So, let's just forget about information
> leak via freeing or not freeing here.  It's the wrong battle field.

Andrew, are you OK with closing the hole with pid_no_revalidate()
and 0600 /proc/slabinfo?  If so, I feel I have to start this discussion
with people participating in the discussion above: Theodore, Dan, Linus, etc.

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
