Date: Thu, 29 Mar 2018 14:50:36 -0600
From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [RFC PATCH v21 0/6] mm: security: ro protection for dynamic
 data
Message-ID: <20180329145036.00155b1e@lwn.net>
In-Reply-To: <5b2a6d5d-5e33-614b-c362-c02a99509def@gmail.com>
References: <20180327153742.17328-1-igor.stoppa@huawei.com>
	<20180327105509.62ec0d4d@lwn.net>
	<5b2a6d5d-5e33-614b-c362-c02a99509def@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
To: Igor Stoppa <igor.stoppa@gmail.com>
Cc: Igor Stoppa <igor.stoppa@huawei.com>, willy@infradead.org, keescook@chromium.org, mhocko@kernel.org, david@fromorbit.com, rppt@linux.vnet.ibm.com, labbott@redhat.com, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 30 Mar 2018 00:25:22 +0400
Igor Stoppa <igor.stoppa@gmail.com> wrote:

> On 27/03/18 20:55, Jonathan Corbet wrote:
> > On Tue, 27 Mar 2018 18:37:36 +0300
> > Igor Stoppa <igor.stoppa@huawei.com> wrote:
> >   
> >> This patch-set introduces the possibility of protecting memory that has
> >> been allocated dynamically.  
> > 
> > One thing that jumps out at me as I look at the patch set is: you do not
> > include any users of this functionality.  Where do you expect this
> > allocator to be used?  Actually seeing the API in action would be a useful
> > addition, I think.  
> 
> Yes, this is very true.
> Initially I had in mind to use LSM hooks as easy example, but sadly they 
> seem to be in an almost constant flux.
> 
> My real use case is to secure both those and the SELinux policy DB.
> I have said this few times, but it didn't seem to be worth mentioning in 
> the cover letter.

In general, it is quite hard to merge a new API without users to go along
with it.  Among other things, that's how reviewers can see how well the
API works in real-world use.  I am certainly not the one who will make the
decision on whether this goes in, but I suspect that whoever *does* make
that decision would prefer to see some users.

Thanks,

jon
