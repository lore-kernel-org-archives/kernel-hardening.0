Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 14 Feb 2016 18:33:24 -0500
From: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20160214233324.GA28274@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] Two interesting papers I've been reading (or, ASLR is not enough)
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Perhaps these techniques are well known in the security world (after
all, these papers are 2-3 years old), but I'm just a kernel progammer,
and I don't have time to necessarily keep up with the latest papers
coming out of academia regarding security (it's hard enough keeping up
with all of the papers out from the file system and storage
community!).  As a result, they were eye-opening to me in terms of
what the exploit writers have been working on:

Kevin Snow, Fabian Monrose, Lucas Davi, and Alexandra Dmitrienko.
"Just-In-Time Code Reuse: On the Effectiveness of Fine-Grained Address
Space Layout Randomization".  2013 IEEE Symptosium on Security and
Privacy.
http://www.ieee-security.org/TC/SP2013/papers/4977a574.pdf

Michael Backes, Thorsten Holz, Benjamin Kollenda, Philipp Koppe,
Stefan Nürnberger, and Jannik Pewny.  "You Can Run but You Can’t Read:
Preventing Disclosure Exploits in Executable Code".  CCS 2014.
https://www.infsec.cs.uni-saarland.de/wp-content/uploads/sites/2/2014/10/nuernberger2014ccs_disclosure.pdf

Anyway, maybe this is old news for everyone on the list, but if you
haven't read these papers, IMO they are definitely worth a read.  Does
anyone have a list of interesting security papers that might be of
interest to kernel programmers who want to know what the security
researchers have been up to?

Cheers,

					- Ted
