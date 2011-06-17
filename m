Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Fri, 17 Jun 2011 19:58:15 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110617155815.GA22756@albatros>
References: <20110617152912.GA21885@albatros>
 <4DFB7605.9000909@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFB7605.9000909@redhat.com>
Subject: [kernel-hardening] Re: [RFC v1] security: introduce ptrace_task_access_check()
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, apparmor@lists.ubuntu.com, "selinux@tycho.nsa.gov Stephen Smalley" <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>, John Johansen <john.johansen@canonical.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 17, 2011 at 11:43 -0400, Eric Paris wrote:
> No need to rename the function

The rename would cause renames in procfs, kernel/ptrace.c and similar
places.

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
