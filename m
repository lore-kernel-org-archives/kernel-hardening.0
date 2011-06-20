Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 20 Jun 2011 18:43:28 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110620144328.GA11933@albatros>
References: <20110617171152.GA1389@albatros>
 <4DFF5795.9080609@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFF5795.9080609@redhat.com>
Subject: [kernel-hardening] Re: [RFC v2] security: intoduce ptrace_task_may_access_current
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, apparmor@lists.ubuntu.com, "selinux@tycho.nsa.gov Stephen Smalley" <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>, John Johansen <john.johansen@canonical.com>, kernel-hardening@lists.openwall.com, serge@hallyn.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 20, 2011 at 10:22 -0400, Eric Paris wrote:
> serge even if you disagree with all of that, you are definitely
> going to need to review the capability changes added here.
> Personally I'd like to see all of the capability changes done as a
> separate patch from the ptrace changes.

I'm afraid the patch series will not be bisectable (capabilities and
ptrace code are very interconnected), but I'll try.


-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
