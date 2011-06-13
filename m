Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 13 Jun 2011 10:42:52 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110613064252.GB3877@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] destroy unused shmem segments
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

I'm looking into the -ow patch and I see this code:

	#ifdef CONFIG_HARDEN_SHM
	void shm_exit (void)
	{
		int i;
		struct shmid_kernel *shp;

		for (i = 0; i <= shm_ids.max_id; i++) {
			shp = shm_get(i);
			if (!shp) continue;

			if (shp->shm_cprid != current->pid) continue;

			if (shp->shm_nattch <= 0) {
				shp->shm_flags |= SHM_DEST;
				shm_destroy (shp);
			}
		}
	}
	#endif


	NORET_TYPE void do_exit(long code)
	{
		...
	#ifdef CONFIG_HARDEN_SHM
		shm_exit();
	#endif
		...
	}

However, the shm segment should be already freed by exit_mm() => vma->close():

	static struct vm_operations_struct shm_vm_ops = {
		open:	shm_open,	/* callback for a new vm-area open */
		close:	shm_close,	/* callback for when the vm-area is released */
		nopage:	shmem_nopage,
	};

	static void shm_close (struct vm_area_struct *shmd)
	{
		...
		shp->shm_nattch--;
	#ifdef CONFIG_HARDEN_SHM
		if(shp->shm_nattch == 0) {
			shp->shm_flags |= SHM_DEST;
			shm_destroy (shp);
		}
	#else
		if(shp->shm_nattch == 0 &&
		   shp->shm_flags & SHM_DEST)
			shm_destroy (shp);
	#endif
		...
	}

Is it some additional "safety" check or a workaround for some dubious
race?  I see no explicit need of such freeing cycle in do_exit().

Thanks,

-- 
Vasiliy
