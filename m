Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Tue, 14 Jun 2011 21:51:31 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110614175130.GA11529@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [kernel-hardening] destroy unused shmem segments
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

> +- shm_orphan_denied

> +shm_orphan_denied:

> +		.procname	= "shm_orphans_denied",

Oops, a typo.

Also maybe it should be named as "shm_forced_ipc_rmid" or just
"shm_forced_rmid"?  I dunno.

-- 
Vasiliy Kulikov
