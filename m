Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sat, 18 Jun 2011 14:42:07 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110618104207.GA13752@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] proc info restrictions problem
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

I'm trying to adapt HARDEN_PROC restrictions to taskstats and proc
connector and stuck with a problem.  proc connector is a special
broadcast netlink socket that gathers all proc information (fork, exit,
exec).  There is one mechanism to filter the data coming into actual
receiving sockets:

int netlink_broadcast_filtered(..., void (*filter)(sock, skb, data), data)

"sock" is receiving socket, filter answers whether the skb should be
send to "sock".

The thing is a socket has no actual information about what specific task
owns it as it might be owned by multiple tasks simultaneously.  So, I
cannot check for PTRACE_MODE_READ as I have only "struct cred*", not
"struct task_struct*".  Some LSMs use only cred part of task, but SMACK
already uses some information from task_struct, so changing ptrace and LSM
interface is impossible.

Manual check for {e,r,fs,s}{u,g}id and capabilities via
cap_ptrace_access_check() might not be sufficient because of possible
additional LSM restrictions and policies.

I feel doubt whether ptrace_may_access() may be changed to something
more simple.  Both -ow and -grsecurity use changed posix permissions and
gid on procfs files, so maybe just match subject's euid vs. object's uid?


Thanks,

-- 
Vasiliy
