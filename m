Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20110620103917.GA5230@albatros>
References: <alpine.LRH.2.00.1106192154220.7503@taiga.selinuxproject.org>
	<alpine.LRH.2.00.1106201455560.6055@tundra.namei.org>
	<20110620103917.GA5230@albatros>
Date: Mon, 20 Jun 2011 16:58:10 +0300
Message-ID: <BANLkTimb==tuDKQ2jyYS+Py0FfNxKVc+Pg@mail.gmail.com>
From: Alexey Dobriyan <adobriyan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [RFC 2/5 v4] procfs: add hidepid= and gid= mount options
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: James Morris <jmorris@namei.org>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

gid= is bad choice because
a) e. g. VFAT uses uid=/gid= mount options to make all inodes to have
certain uid/gid
b) uid=/gid=, IIRC, will be added as generic VFS mount options (like ro)
   with semantics described in a)

so having different semantics for /proc won't be good.
